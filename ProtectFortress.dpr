program ProtectFortress;

uses
  Forms,
  unt_Principal in 'unt_Principal.pas' {frm_Protect};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Protect, frm_Protect);
  Application.Run;
end.
