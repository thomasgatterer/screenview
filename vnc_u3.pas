unit vnc_u3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,
  INIFiles;

type

  { T_PLATZ }

  T_PLATZ = class(TButton)
    public
      IP: string;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BTN_EXIT: TButton;
    CB_VIEWONLY: TCheckBox;
    CB_FULLSCREEN: TCheckBox;
    PANEL_F8: TPanel;
    Process1: TProcess;
    procedure FormCreate(Sender: TObject);
    procedure BTN_EXITClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    PCs: TStringList;
  public
    { public declarations }
    procedure CALL_VNC(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  BTN_WIDTH = 70;
  BTN_HEIGHT = 50;

var
  MAX_ZEILE,MAX_SPALTE: integer;
  VIEWER: string;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  PLATZ: T_PLATZ;
  INI_FILE: TIniFile;
  I,P,SPALTE,ZEILE,ERR: integer;
  PC_VALUE,PC_NAME,INFO,INI_FILE_STR: string;
begin
  MAX_ZEILE := 0;
  MAX_SPALTE := 0;
  INI_FILE_STR := ParamStr(1);
  PCs := TStringList.Create;
  INI_FILE := TIniFile.Create(INI_FILE_STR);
  INI_FILE.ReadSectionValues('PCs',PCs);
  VIEWER := INI_FILE.ReadString('VIEWER','PROG','vncviewer');
  CB_VIEWONLY.Checked :=
    (UpperCase(INI_FILE.ReadString('VIEWER','VIEWONLY','YES')) = 'YES') or
    (UpperCase(INI_FILE.ReadString('VIEWER','VIEWONLY','YES')) = 'TRUE');
  CB_FULLSCREEN.Checked :=
    (UpperCase(INI_FILE.ReadString('VIEWER','FULLSCREEN','YES')) = 'YES') or
    (UpperCase(INI_FILE.ReadString('VIEWER','FULLSCREEN','YES')) = 'TRUE');
  INFO := INI_FILE.ReadString('INFO','TEXT','');
  for I := 0 to PCs.Count-1 do
    begin
      PCs.GetNameValue(I,PC_NAME,PC_VALUE);
      P := pos(',',PC_VALUE);
      val(copy(PC_VALUE,1,P-1),ZEILE,ERR);
      delete(PC_VALUE,1,P);
      val(copy(PC_VALUE,1,P-1),SPALTE,ERR);
      delete(PC_VALUE,1,P);
      PLATZ := T_PLATZ.Create(self);
      PLATZ.Parent := self;
      PLATZ.top  := 20 + (BTN_HEIGHT+20)*ZEILE;
      PLATZ.Left := 20 + (BTN_WIDTH+20)*SPALTE;
      PLATZ.height := BTN_HEIGHT;
      PLATZ.width := BTN_WIDTH;
      PLATZ.visible := true;
      PLATZ.IP := PC_VALUE;
      PLATZ.Caption := PC_NAME;
      PLATZ.OnClick := @CALL_VNC;
      if (ZEILE > MAX_ZEILE) then MAX_ZEILE := ZEILE;
      if (SPALTE > MAX_SPALTE) then MAX_SPALTE := SPALTE;
    end;
  BTN_EXIT.Top := (MAX_ZEILE+1)*(BTN_HEIGHT+20) + 30;

  Form1.Height := BTN_EXIT.top + BTN_EXIT.Height + 20;
{
if Form1.Height < ( then Form1.Height := 200;
}
  Form1.Width  := (MAX_SPALTE+1)*(BTN_WIDTH+20) + 30;
  if Form1.Width < 400 then Form1.Width := 400;
  PANEL_F8.Caption := INFO;
  if ((UpperCase(VIEWER) = 'XVNCVIEWER')) and (INFO = '') then
    PANEL_F8.Caption := 'Verlassen des Viewers mit Taste F8';
  if PANEL_F8.Caption = '' then
    PANEL_F8.Hide
  else
    begin
      PANEL_F8.Top := Form1.Height;
      Form1.Height := Form1.Height + Panel_F8.Height;
      PANEL_F8.Left := 0;
      PANEL_F8.Width := Form1.Width;
      PANEL_F8.Show;
    end;

  BTN_EXIT.Left := Form1.Width - BTN_EXIT.Width - 30;
  CB_VIEWONLY.Left := 20;
  CB_VIEWONLY.Top := BTN_EXIT.Top;
  CB_FULLSCREEN.Left := CB_VIEWONLY.Left + CB_VIEWONLY.Width +20;
  CB_FULLSCREEN.Top := BTN_EXIT.Top;
  INI_FILE.Destroy;
end;

procedure TForm1.CALL_VNC(Sender: TObject);
begin
  Process1.Executable := VIEWER;
  Process1.Parameters.Clear;
  if CB_VIEWONLY.Checked then
    Process1.Parameters.Add('-viewonly');
  if CB_FULLSCREEN.Checked then
    Process1.Parameters.Add('-fullscreen');
  Process1.Parameters.Add(T_PLATZ(Sender).IP);
  Process1.Execute;
end;

procedure TForm1.BTN_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PCs.Destroy;
end;

end.

