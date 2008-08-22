#ifdef _BPF

#include "ethcard.h"

#define ETHERTYPE_8021X 0x888e

static static struct bpf_insn insns[] = {
	BPF_STMT(BPF_LD+BPF_H+BPF_ABS, 12),//加载halfword以太网链路层的type
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ETHERTYPE_8021X, 0, 1),//判断是否是802.1X数据包，是则返回给本程序
	BPF_STMT(BPF_RET+BPF_K, (u_int)-1),
	BPF_STMT(BPF_RET+BPF_K, 0),
};



static THREAD *thread_ethcard_recv = NULL;


INT   get_ethcard_iface_byname(int sd, CHAR *name)
{
	int ret;
	struct ifreq req;
	strncpy(req.ifr_name,name,IFNAMSIZ);
	ret=ioctl(sd,SIOCGIFINDEX,&req);
	if (ret==-1) return -1;
	return req.ifr_ifindex;
}


INT get_ethcards(ETHCARD_INFO *devices, INT bufsize)
{
	int fd, i, count = 0;
	struct ifreq buf[MAX_ETHCARDS];
	struct ifconf ifc;

	if ((fd = socket(AF_INET, SOCK_DGRAM, 0)) >= 0) 
	{
		ifc.ifc_len = sizeof(buf);
		ifc.ifc_buf = (caddr_t)buf;
		if (!ioctl(fd, SIOCGIFCONF, (char *) &ifc)) 
		{
			count = ifc.ifc_len / sizeof(struct ifreq);
			i = count;
			while (i-- > 0)
			{
				strcpy(devices[i].name, buf[i].ifr_name);
				strcpy(devices[i].desc, buf[i].ifr_name);
				
				/*Jugde whether the net card status is up*/
				if (!(ioctl(fd, SIOCGIFFLAGS, (char *) &buf[i])))
				{
					devices[i].live = (buf[i].ifr_flags & IFF_UP);
				}
				
				/*Get IP of the net card */
				if (!(ioctl(fd, SIOCGIFADDR, (char *) &buf[i]))) 
				{
					strcpy(devices[i].ip, inet_ntoa(((struct sockaddr_in *) (&buf[i].ifr_addr))->sin_addr));
				}

				
				/*Get HW ADDRESS of the net card */
				if (!(ioctl(fd, SIOCGIFHWADDR, (char *) &buf[i])))
				{
					snprintf(devices[i].mac, sizeof(devices[i].mac),
					    "%02x %02x %02x %02x %02x %02x",
						(unsigned char) buf[i].ifr_hwaddr.sa_data[0],
						(unsigned char) buf[i].ifr_hwaddr.sa_data[1],
						(unsigned char) buf[i].ifr_hwaddr.sa_data[2],
						(unsigned char) buf[i].ifr_hwaddr.sa_data[3],
						(unsigned char) buf[i].ifr_hwaddr.sa_data[4],
						(unsigned char) buf[i].ifr_hwaddr.sa_data[5]
						);
				}
			}
		} 
	}
	close(fd);

	return count;
}




INT		ethcard_send_packet(ETHCARD *ethcard, BYTE *buf, INT len)
{
    write(ethcard->fd, buf, len);
}


static THREADRET raw_socket_loop_thread(THREAD *self)
{
	CHAR buf[2*32767];
	
	ETHCARD_LOOP_RECV_PROC_PARAM *pp, p;
	size_t len = 0;

	fd_set set;
	struct timeval tv;

	
	pp = (ETHCARD_LOOP_RECV_PROC_PARAM *)self->param;
	p.ethcard = pp->ethcard;
	p.proc = pp->proc;

	BYTE *pkt_data;

	os_thread_init_complete(self);	

	while(os_thread_is_running(self) || os_thread_is_paused(self))
	{
		tv.tv_sec = 0;
		tv.tv_usec = 0;
		FD_ZERO(&set);
		FD_SET(p.ethcard->fd, &set);
		select(p.ethcard->fd + 1, &set, NULL, NULL, &tv);
		if( FD_ISSET(p.ethcard->fd, &set) )
		{
			len = read(p.ethcard->fd, buf, sizeof(buf));
			
			if(len > 0)
			{
				p.proc(p.ethcard, pkt_data, recvlen);
			}
			else
			{
				//must be something wrong....
			}			
		}
		else
		{
			os_sleep(20);
		}
		os_thread_test_paused(self);
	}
	thread_ethcard_recv = os_thread_free(thread_ethcard_recv);	
	return 0;
}

VOID ethcard_start_loop_recv(ETHCARD *ethcard, ETHCARD_LOOP_RECV_PROC proc)
{
	ETHCARD_LOOP_RECV_PROC_PARAM p;



	p.ethcard = ethcard;
	p.proc = proc;


	//dprintf("ethcard_start_loop_recv");
	thread_ethcard_recv = os_thread_create(raw_socket_loop_thread, (POINTER)&p, TRUE, FALSE);

}


VOID ethcard_stop_loop_recv()
{
	//dprintf("ethcard_stop_loop_recv");
	os_thread_kill(thread_ethcard_recv);
	while(thread_ethcard_recv) os_sleep(20);
}

ETHCARD *ethcard_open(char *name)
{
	ETHCARD *ec = NULL;
    struct ifreq ifr;
    struct bpf_program bpf_pro={4,insns};
	
    int bpf;
    int blen;
    
    int i;
    
    char device[sizeof "/dev/bpf000"];

    /*
     *  Go through all the minors and find one that isn't in use.
     */
    for (i = 0;;i++)
    {
        sprintf(device, "/dev/bpf%d", i);

        bpf = open(device, O_RDWR);
        if (bpf == -1 && errno == EBUSY)
        {
            /*
             *  Device is busy.
             */
            continue;
        }
        else
        {
            /*
             *  Either we've got a valid file descriptor, or errno is not
             *  EBUSY meaning we've probably run out of devices.
             */
            break;
        }
    }
        
	if( bpf == -1 )
	{
		dprintf("open /dev/bpf%d error", i);
		return NULL;
	}
	
	strcpy(ifr.ifr_name, name);
	
	if( (-1==ioctl(bpf,BIOCGBLEN,&blen))||(-1==ioctl(bpf,BIOCSETIF,&ifr))||
		(-1==ioctl(bpf,BIOCSETF,&bpf_pro))||(-1==ioctl(bpf,BIOCFLUSH))||(-1==ioctl(bpf,BIOCSRTIMEOUT,&timeout)))
	{
		dprintf("ioctl error");
		close(bpf);
		return NULL;
	}
	
	ec = os_new(ETHCARD, 1);
	
	ec->fd = bpf
	ec->blen = blen;
	
	return ec;
}

ETHCARD *ethcard_close(ETHCARD *ethcard)
{
	if(ethcard)
	{
		close(ethcard->fd);
		os_free(ethcard);
	}
	return NULL;
}


VOID	ethcard_init()
{
	thread_ethcard_recv = NULL;
}

VOID	ethcard_cleanup()
{
	os_thread_kill(thread_ethcard_recv);
	while(thread_ethcard_recv) os_sleep(20);
}


#endif //_BPF

