#include "../ethcard.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#include "../os.h"
#include "../des.h"
#include "../md5.h"
#include "../logs.h"
#include "../tunet.h"
#include "../dot1x.h"

#include "../userconfig.h"
#include "../mytunet.h"
#include "../util.h"
#include "../setting.h"
#include "../mytunetsvc.h"


/*
THREAD *thread_show_logs;

THREADRET show_logs_thread(THREAD *self)
{
    LOG *log;
    while(os_thread_is_running(self) || os_thread_is_paused(self))
    {
        log = logs_fetch(g_logs, 0);

        if(log)
        {
            printf("LOG: %s  (%s)\n\n", log->tag, log->str);

            log = log_free(log);
        }

        os_sleep(10);
        os_thread_test_paused(self);
    }

    thread_show_logs = os_thread_free(thread_show_logs);
    return NULL;
}
*/

int main(int argc, char *argv[])
{

    INT bRunByUser = 0;
    CHAR *username, *password, *adapter;
    BOOL  usedot1x;
    INT   language, limitation;
    ETHCARD_INFO ethcards[16];
    INT     ethcardcount;
    INT     i;

    USERCONFIG tmpTestConfig;
    mytunetsvc_get_user_config(&tmpTestConfig);

    mytunetsvc_init();

    //thread_show_logs = os_thread_create(show_logs_thread, NULL, FALSE);

    bRunByUser = (argc != 1);
    if(strlen(tmpTestConfig.szUsername) == 0) bRunByUser = 1;

    if(bRunByUser)
    {
        ethcardcount = get_ethcards(ethcards, sizeof(ethcards));
        if(argc <= 2)
        {
            puts( " MyTunet Service Program\n");

            puts(" Your Network Devices:");
            for(i = 0;i < ethcardcount; i++)
            {
                printf("    %d. %s\n", i, ethcards[i].desc);
            }
            puts("");
/*
            puts(
                    " Usage: mytunet set <adapter_index> <user> <pwd> <0/1 (need 802.1x?)>\n"
                    "                    <C/E (language)> <C/D/N (Campus/Domestic/NoLimit)>\n"
                    "   -- or -- \n"
                    "        mytunet set <adapter_index> <user> <0/1> <C/E> <C/D/N>\n"
                    "          (then you will input the password separetely.)\n"
                    "\n"
                    "  For example:  mytunet set 0 wang abcd 1 C D\n"
                   "   \n"
                   "    will set the logon information like this:\n"
                   "     - use the first network device,\n"
                   "     - username is \'wang\',\n"
                   "     - password is \'abcd\',\n"
                   "     - use 802.1x authorization(ONLY for Zijing 1# - 13# users),\n"
                   "     - language is Chinese,\n"
                   "     - open the connection for Domestic.\n"
                   "\n"
                   "  Another example: mytunet set 0 wang 1 C D\n"
                   "       then mytunet will prompt you to input the password.\n"
                   "\n"
                   " !!!==================  NOTICE  ===================!!!\n"
                   "  If you set your PASSWORD by 'mytunet set ...',\n"
                   "  you MUST run \'history -c\' to clean your command history,\n"
                   "  or your unencrypted password may leave in your system!!\n"
                   );
*/
            puts(
                    " Usage: mytunet set <adapter_index> <username> <0/1 (need 802.1x?)>\n"
                    "                    <C/E (language)> <C/D/N (Campus/Domestic/NoLimit)>\n"
                    "          (then you will input the password separetely.)\n"
                    "\n"
                    "  For example:  mytunet set 0 wang abcd 1 C D\n"
                   "   \n"
                   "    will set the logon information like this:\n"
                   "     - use the first network device,\n"
                   "     - username is \'wang\',\n"
                   "     - use 802.1x authorization(ONLY for Zijing 1# - 13# users),\n"
                   "     - language is Chinese,\n"
                   "     - open the connection for Domestic.\n"
                   "\n"
                   "    then mytunet will prompt you to input the password.\n"
                   );
        }
        else
        {
            if(strcmp(argv[1], "set") == 0)
            {
                //if(argc != 8 && argc != 7)
                if(argc != 7)
                {
                    puts(" Wrong usage !");
                    return ERR;
                }

                i = 2;
                adapter = ethcards[atoi(argv[i++])].name;
                username = argv[i++];
                if(argc == 8)
                {
                    password = argv[i++];
                }
                else
                {
                    /*
                    struct termios term, termsave;
                    char *p;

                    printf("Password:");
                    tcgetattr(STDIN_FILENO, &term);
                    tcgetattr(STDIN_FILENO, &termsave);
                    term.c_lflag &= ~(ECHO);
                    tcsetattr(STDIN_FILENO, TCSANOW, &term);
                    fgets(inputbuf, sizeof(inputbuf), stdin);
                    inputbuf[sizeof(inputbuf) - 1] = 0;
                    tcsetattr(STDIN_FILENO, TCSANOW, &termsave);

                    for(p = inputbuf + strlen(inputbuf) - 1; *p == '\n' || *p == '\r'; p--)
                        *p = 0;
                    puts("");

                    password = inputbuf;
                    */

                }
                usedot1x = atoi(argv[i++]);

                switch(tolower(argv[i++][0]))
                {
                    case 'e':
                        language = 0;
                        break;
                    case 'c':
                        language = 1;
                        break;
                    default:
                        language = 0;
                        break;

                }

                switch(tolower(argv[i++][0]))
                {
                    case 'c':
                        limitation = LIMITATION_CAMPUS;
                        break;
                    case 'd':
                        limitation = LIMITATION_DOMESTIC;
                        break;
                    case 'n':
                        limitation = LIMITATION_NONE;
                        break;
                    default:
                        limitation = LIMITATION_DOMESTIC;
                        break;
                }

                mytunetsvc_set_user_config(username, password, 0,
                                        adapter, limitation, language);
                mytunetsvc_set_user_config_dot1x(usedot1x, 0);

                return OK;
            }
            puts(" Wrong usage !");
        }

    }
    else
    {
        mytunetsvc_get_user_config(&g_UserConfig);
        mytunetsvc_main(0, NULL);
    }

    mytunetsvc_cleanup();
    return 0;
}
