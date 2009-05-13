unit main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Registry, IniFiles, SHELLAPI;

const NetWorkReg = '\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}';
type
    TMainForm = class(TForm)
        Label1: TLabel;
        ConnComboBox: TComboBox;
        Label2: TLabel;
        ProfileComboBox: TComboBox;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        SaveBtn: TButton;
        DeleteBtn: TButton;
        ApplyBtn: TButton;
        ExitBtn: TButton;
        ipFld: TEdit;
        netMaskFld: TEdit;
        gateWayFld: TEdit;
        Label7: TLabel;
        Label6: TLabel;
        procedure ApplyBtnClick(Sender: TObject);
        procedure ProfileComboBoxSelect(Sender: TObject);
        procedure DeleteBtnClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure SaveBtnClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure ExitBtnClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    MainForm: TMainForm;
    inifile: TINIfile;
implementation

{$R *.dfm}

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
    MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var reg: TRegistry;
    SubKey, values, Profiles: TStringList;
    i: integer;
begin
    Application.Title := 'MyTunet IP�л�����';
    //==============================��ע����з��������������=====================
    reg := TRegistry.Create;
    SubKey := TStringList.Create;
    values := TStringList.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly(NetWorkReg);
    reg.GetKeyNames(SubKey);
    for i := 0 to SubKey.Count - 1 do
    begin

        if (reg.KeyExists(NetWorkReg + '\' + SubKey[i] + '\Connection')) then
        begin
            reg.OpenKeyReadOnly(NetWorkReg + '\' + SubKey[i] + '\Connection');
            values.Clear;
            reg.GetValueNames(values);
            if (values.IndexOf('ShowIcon') >= 0) then
                //if (reg.ReadInteger('ShowIcon')=0) then
                ConnComboBox.Items.Add(reg.ReadString('Name'));
        end;
    end;
    reg.CloseKey;
    if (ConnComboBox.Items.Count > 0) then
        ConnComboBox.ItemIndex := 0;
    SubKey.Destroy;
    values.Destroy;



    //=================================INI�����ļ���ʼ��===========================
    inifile := TInifile.Create(ExtractFilePath(paramstr(0)) + 'profiles.ini');
    Profiles := TStringList.Create;
    inifile.ReadSections(Profiles);
    for i := 0 to Profiles.Count - 1 do
        ProfileComboBox.Items.Add(Profiles[i]);
end;

procedure TMainForm.SaveBtnClick(Sender: TObject);
var profileName: string;
begin
    profileName := ProfileComboBox.Text;
    if (profileName = '') then
    begin
        showMessage('���ò���Ϊ��');
        exit;
    end;
    if (profileName = 'DHCP') then
    begin
        showMessage('DHCPΪ�������ã����ɸ���');
        exit;
    end;
    if (ProfileComboBox.Items.IndexOf(ProfileComboBox.Text) >= 0) then
    begin
        if (Application.MessageBox(PAnsiChar('����' + ProfileComboBox.Text + '�Ѵ��ڣ�Ҫ������'), '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) <> 1) then
            exit;
    end
    else
        ProfileComboBox.Items.Add(ProfileComboBox.Text);
    inifile.WriteString(ProfileComboBox.Text, 'IP', IPFld.Text);
    inifile.WriteString(ProfileComboBox.Text, 'NetMask', netMaskFld.Text);
    inifile.WriteString(ProfileComboBox.Text, 'GateWay', gateWayFld.Text);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var i: integer;
begin
    inifile.Destroy;
end;

procedure TMainForm.DeleteBtnClick(Sender: TObject);
var profileName: string;
begin
    profileName := ProfileComboBox.Text;
    if (profileName = 'DHCP') then
    begin
        showMessage('DHCPΪ�������ã�����ɾ��');
        exit;
    end;
    inifile.EraseSection(profileName);
    if (ProfileComboBox.Items.IndexOf(profileName) >= 0) then
        ProfileComboBox.Items.Delete(ProfileComboBox.Items.IndexOf(profileName));
end;

procedure TMainForm.ProfileComboBoxSelect(Sender: TObject);
begin
    IPFld.Text := inifile.ReadString(ProfileComboBox.Text, 'IP', '');
    netMaskFld.Text := inifile.ReadString(ProfileComboBox.Text, 'NetMask', '');
    gateWayFld.Text := inifile.ReadString(ProfileComboBox.Text, 'GateWay', '');
end;

procedure TMainForm.ApplyBtnClick(Sender: TObject);
var pre, ipconfig: string;
begin
    pre := 'interface ip set address "' + ConnComboBox.Text + '" ';
    if (ipfld.Text = '') and (ProfileComboBox.Text = 'DHCP') then
    begin
        ipconfig := ' dhcp';
    end else begin
        ipconfig := ' static ' + ipfld.Text + ' ' + netmaskfld.Text + ' ' + gateWayFld.Text + ' 1';
    end;

    if MessageBox(Handle, PChar('��Ҫ���е����' + chr(10) + 'netsh ' + pre + ipconfig), '��ȷ��' , MB_YESNO + MB_ICONQUESTION ) = IDYES then
        ShellExecute(handle, 'open', 'netsh', PAnsiChar(pre + ipconfig), '', SW_SHOW);
end;

end.

