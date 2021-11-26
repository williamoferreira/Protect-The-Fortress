unit unt_Principal;
// Neste jogo, para medir o n�vel de dano dos atores, ou utilizado a propriedade
// TAG do TImage, ele t� l� pra quebrar galho mesmo...Quando o ator n�o tem dano
// TAG vale 0 (Zero) e quando est� destruido, Tag vale 100. Simples assi, OI...
// Controles:
//    A - Desloca a mira para a esquerda
//    D - Desloca a mira para a direita
//    K - Atira
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Math, MPlayer, MMsystem;

const
  VELOCIDADE_DISPARO = 5;

type

  TPrimeThrd = class(TThread)
    protected
       procedure Execute; override;
  end;

  Tfrm_Protect = class(TForm)
  {$REGION 'Propriedades e m�todos do formul�rio'}
    img_Aviao: TImage;
    img_Canhao: TImage;
    img_Bomba: TImage;
    img_Disparo: TImage;
    tmr_Aviao: TTimer;
    tmr_Bomba: TTimer;
    img_explosao: TImage;
    tmr_Disparo: TTimer;
    img_Mira: TImage;
    tmr_Explosao: TTimer;
    Img_ManutencaoCanhaoBG: TImage;
    img_ManutencaoCanhao: TImage;
    img_AviaoManuBG: TImage;
    Img_AviaoManu: TImage;
    img_Fundo: TImage;
    img_Inimigo: TImage;
    img_Voce: TImage;
    img_1: TImage;
    img_2: TImage;
    img_3: TImage;
    img_4: TImage;
    img_5: TImage;
    img_6: TImage;
    img_7: TImage;
    img_8: TImage;
    Image1: TImage;
    img_Disparo2: TImage;
    Img_Disparo3: TImage;
    tmr_Disparo2: TTimer;
    tmr_Disparo3: TTimer;
    img_GameOver: TImage;
    Img_Fortress: TImage;
    procedure tmr_AviaoTimer(Sender: TObject);
    procedure tmr_BombaTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmr_DisparoTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tmr_ExplosaoTimer(Sender: TObject);
    procedure tmr_Disparo2Timer(Sender: TObject);
    procedure tmr_Disparo3Timer(Sender: TObject);
  {$ENDREGION}
  private
    function Disparo: TPoint;
    function Bomba: TPoint;
    function Aviao: TPoint;
    function Canhao: TPoint;
    procedure Inicializar;
    function RectAviao: TRect;
    function RectBomba: TRect;
    procedure AtualizaPontos;
    function Disparo2: TPoint;
    function Disparo3: TPoint;
    function Fortress: TPoint;

    { Private declarations }
  public
    { Public declarations }
  end;

var

  frm_Protect: Tfrm_Protect;
  Angulo : Extended = 180;
  PosX, PosY : Integer;
  PosX2, PosY2 : Integer;
  PosX3, PosY3 : Integer;
  MAX_X, MAX_Y, MIN_X, MIN_Y : Integer;
  Pontos : 0..99999999;
  Vidas : Integer = 0;
  NewThread: TPrimeThrd;

implementation

uses Types;

{$R *.dfm}

procedure TPrimeThrd.Execute;
begin
  Repeat
    PlaySound('.\Audio\bgMusic.wav',0,0);
  Until Application.Terminated;
end;


{$REGION 'Atualiza o display de pontua��o localizado no alto da tela'}
Procedure Tfrm_Protect.AtualizaPontos;
var
  StrPontos : String[8];
begin
  StrPontos := IntToStr(Pontos);
  StrPontos := FormatFloat('00000000',Pontos);
  img_1.Picture.LoadFromFile('.\numeros\' + StrPontos[1] + '.bmp');
  img_2.Picture.LoadFromFile('.\numeros\' + StrPontos[2] + '.bmp');
  img_3.Picture.LoadFromFile('.\numeros\' + StrPontos[3] + '.bmp');
  img_4.Picture.LoadFromFile('.\numeros\' + StrPontos[4] + '.bmp');
  img_5.Picture.LoadFromFile('.\numeros\' + StrPontos[5] + '.bmp');
  img_6.Picture.LoadFromFile('.\numeros\' + StrPontos[6] + '.bmp');
  img_7.Picture.LoadFromFile('.\numeros\' + StrPontos[7] + '.bmp');
  img_8.Picture.LoadFromFile('.\numeros\' + StrPontos[8] + '.bmp');
end;
{$ENDREGION}

{$REGION 'Fun��es que retornam o centro dos objetos:  Aviao - Disparo - Bomba - Canhao - Fortress'}
Function TFrm_Protect.Fortress : TPoint;
begin
  Result.X := Img_Fortress.Left + (Img_Fortress.Width div 2);
  Result.Y := Img_Fortress.Top  + (Img_Fortress.Height div 2);
end;

Function TFrm_Protect.Canhao : TPoint;
begin
  Result.X := img_Canhao.Left + (img_Canhao.Width div 2);
  Result.Y := img_Canhao.Top  + (img_Canhao.Height div 2);
end;

Function TFrm_Protect.Disparo : TPoint;
begin
  Result.X := img_Disparo.Left + (img_Disparo.Width div 2);
  Result.Y := img_Disparo.Top  + (img_Disparo.Height div 2);
end;

Function TFrm_Protect.Disparo2 : TPoint;
begin
  Result.X := img_Disparo2.Left + (img_Disparo2.Width div 2);
  Result.Y := img_Disparo2.Top  + (img_Disparo2.Height div 2);
end;

Function TFrm_Protect.Disparo3 : TPoint;
begin
  Result.X := img_Disparo3.Left + (img_Disparo3.Width div 2);
  Result.Y := img_Disparo3.Top  + (img_Disparo3.Height div 2);
end;

Function TFrm_Protect.Bomba : TPoint;
begin
  Result.X := img_Bomba.Left + (img_Bomba.Width div 2);
  Result.Y := img_Bomba.Top  + (img_Bomba.Height div 2);
end;

Function TFrm_Protect.Aviao : TPoint;
begin
  Result.X := img_Aviao.Left + (img_Aviao.Width div 2);
  Result.Y := img_Aviao.Top + (img_Aviao.Height div 2);
end;
{$ENDREGION}

{$REGION 'Fun��es que retornam um Rect da posi��o do Avi�o e da Bomba'}
Function TFrm_Protect.RectAviao : TRect;
begin
  Result.Left   := img_Aviao.Left;
  Result.Right  := img_Aviao.Left + img_Aviao.Width;
  Result.Top    := img_Aviao.Top;
  Result.Bottom := img_Aviao.Top + img_Aviao.Height;
end;

Function TFrm_Protect.RectBomba : TRect;
begin
  Result.Left   := img_Bomba.Left;
  Result.Right  := img_Bomba.Left + img_Bomba.Width;
  Result.Top    := img_Bomba.Top;
  Result.Bottom := img_Bomba.Top + img_Bomba.Height;
end;
{$ENDREGION}

{$REGION 'Inicializa��o/Reset das vari�veis'}
Procedure TFrm_Protect.Inicializar;
begin
  randomize;
  img_GameOver.Visible := False;
  img_GameOver.Left := (img_Fundo.Width div 2) - (img_GameOver.Width div 2);
  img_GameOver.Top  := (img_Fundo.Height div 2) - (img_GameOver.Height div 2);

  //DoubleBuffered := true;

  {Posicionando a posi��o inicial do Canh�o, avi�o e da Mira}
  img_Aviao.Left    := 0 - img_Aviao.Width;
  img_Canhao.Left   := (img_Fundo.Width div 2) - (img_Canhao.Width div 2);
  img_Mira.Left     := Round(Sin(DegToRad(Angulo)) * 100) + Canhao.X - (img_Mira.Width div 2);
  img_Mira.Top      := Round(Cos(DegToRad(Angulo)) * 100) + Canhao.Y - (img_Mira.Height div 2);
  img_Mira.Visible  := True;
  tmr_Aviao.Enabled := true;

  {Definindo valores da �rea que o disparo pode alcan�ar, Vari�veis apenas para
  melhorar a leitura do c�digo j� que os valores n�o sofrer�o altera��es}
  MAX_X := img_Fundo.Width;
  MAX_Y := img_Fundo.Height;
  MIN_X := 0;
  MIN_Y := 0;

  Pontos := 0;
  AtualizaPontos;
end;
{$ENDREGION}

{$REGION 'M�todo para controle do usu�rio - FormKeyPress'}
procedure Tfrm_Protect.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Case UpCase(Key) of
    'A' : if Angulo < 270 then
            Angulo := Angulo + 5;
    'D' : if angulo > 90 then
            Angulo := Angulo - 5;
    #27 : Application.Terminate;
    'K' : begin
            if (tmr_Disparo.Enabled = False) then
              Begin
                img_Disparo.Left := Canhao.X;
                img_Disparo.Top  := Canhao.Y;
                PosX := Round(Sin(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                PosY := Round(Cos(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                tmr_Disparo.Enabled := true;
                img_Disparo.Visible := True;
              end
            else
              if (tmr_Disparo2.Enabled = False) then
                Begin
                  img_Disparo2.Left := Canhao.X;
                  img_Disparo2.Top  := Canhao.Y;
                  PosX2 := Round(Sin(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                  PosY2 := Round(Cos(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                  tmr_Disparo2.Enabled := true;
                  img_Disparo2.Visible := True;
                end
              else
                if (tmr_Disparo3.Enabled = False) then
                  Begin
                    img_Disparo3.Left := Canhao.X;
                    img_Disparo3.Top  := Canhao.Y;
                    PosX3 := Round(Sin(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                    PosY3 := Round(Cos(DegToRad(Angulo)) * VELOCIDADE_DISPARO);
                    tmr_Disparo3.Enabled := true;
                    img_Disparo3.Visible := True;
                  end
          end;
  End;
  img_Mira.Left := Round(Sin(DegToRad(Angulo)) * 100) + Canhao.X - (img_Mira.Width div 2);
  img_Mira.Top  := Round(Cos(DegToRad(Angulo)) * 100) + Canhao.Y - (img_Mira.Height div 2);
end;
{$ENDREGION}

{$REGION 'Inicializa��o das vari�veis e objetos - FormShow'}
procedure Tfrm_Protect.FormShow(Sender: TObject);
begin
  Inicializar;
  NewThread := TPrimeThrd.Create(True);
  NewThread.FreeOnTerminate := True;
  NewThread.Resume;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel pelo Deslocamento do avi�o'}
procedure Tfrm_Protect.tmr_AviaoTimer(Sender: TObject);
begin
  {Para n�o ficar habilitando e desabiltando o timer do avi�o, fiz este random
  para que n�o fique fixo o tempo que o avi�o fica fora da tela. Apenas um
  elemento supresa na brincadeira :D}
  if ((Aviao.X - random(1000)) >= img_Fundo.ClientWidth) then
    begin
      img_Aviao.Left := 0 - img_Aviao.Width;
    end
  else
    begin
      img_Aviao.Left := img_Aviao.Left + 5;
      //Sequencias de IFs para verificar se o avi�o lan�ar� a lan�ada a bomba
      if (tmr_Bomba.Enabled = false) then
        if (Aviao.X < img_Fundo.Width) then
          if ((random(100) mod 50) = 0) then //Para dar 2% de chances de lan�ar a bomba
            begin
              img_Bomba.Top   := Aviao.Y;
              img_Bomba.Left  := Aviao.X - (img_Bomba.Width div 2);
              img_Bomba.Visible := True;
              tmr_Bomba.Enabled := true;
            end;
      //Fim da sequencia de IFs...
    end;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel pelo deslocamento da bomba lan�ada pelo avi�o'}
procedure Tfrm_Protect.tmr_BombaTimer(Sender: TObject);
begin
  if (Bomba.Y >= Fortress.Y) then
    begin
      img_explosao.Left     := Bomba.X - (img_explosao.Width div 2);
      img_explosao.Top      := Bomba.Y - (img_explosao.Height div 2);
      img_Bomba.Visible     := false;
      tmr_Bomba.Enabled     := false;
      img_explosao.Visible  := true;
      tmr_explosao.Enabled  := true;
      img_Canhao.Tag        := img_Canhao.Tag + 5;
      Img_ManutencaoCanhao.Width := Img_ManutencaoCanhao.Width - 5;
      if img_Canhao.Tag >= 100 then
        begin
          Dec(Vidas);
          if (Vidas < 0) then
            begin
              tmr_Aviao.Enabled    := false;
              tmr_Bomba.Enabled    := false;
              tmr_Disparo.Enabled  := false;
              tmr_Disparo2.Enabled := false;
              tmr_Disparo3.Enabled := false;
              img_Mira.Visible     := false;
              img_GameOver.Visible := True;
            end
          else
            begin
              img_ManutencaoCanhao.Width := 100;
              img_Canhao.Tag := 0;
            end;
        end;
    end
  else
    begin
      img_Bomba.Top := img_Bomba.top + 5;
    end;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel pelo 1� disparo do jogoador'}
procedure Tfrm_Protect.tmr_DisparoTimer(Sender: TObject);
begin
  {Deslocamento do Disparo no eixo XY. Valor do deslocamento definido pelas
  Vari�veis PosX e PosY no evento OnKeyPress}
  img_Disparo.Left := img_Disparo.Left + PosX;
  img_Disparo.Top  := img_Disparo.Top + PosY;

  {Verica��o se a posi��o do disparo est� entro dos valores definidos no
  onCreate do formul�rio}
  if ((Disparo.X < 0) or
      (Disparo.X > MAX_X) or
      (Disparo.Y < 0)) Then
    begin
      tmr_Disparo.Enabled := False;
      img_Disparo.Visible := False;
    end
  else
    begin
      //Verificar se colide com a bomba
      if ((Disparo.X > RectBomba.Left) and
          (Disparo.X < RectBomba.Right) and
          (Disparo.Y > RectBomba.Top) and
          (Disparo.Y < RectBomba.Bottom)) then
        begin
          if (tmr_Bomba.Enabled = True) then
            begin
              tmr_Bomba.Enabled     := false;
              tmr_Disparo.Enabled   := false;
              img_Bomba.Visible     := false;
              img_Disparo.Visible   := false;
              img_explosao.Left     := Bomba.X - (img_explosao.Width div 2);
              img_explosao.Top      := Bomba.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := True;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 10);
              AtualizaPontos;
            end;
        end
      else
        begin
          //Verificar se colide com o avi�o
          if ((Disparo.X > RectAviao.Left) and
              (Disparo.X < RectAviao.Right) and
              (Disparo.Y > RectAviao.Top) and
              (Disparo.Y < RectAviao.Bottom)) then
            begin
              tmr_Disparo.Enabled   := False;
              img_Disparo.Visible   := false;
              img_explosao.Left     := Disparo.X - (img_explosao.Width div 2);
              img_explosao.Top      := Disparo.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := true;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 50);
              img_Aviao.Tag := img_Aviao.Tag + 5;
              Img_AviaoManu.Width := Img_AviaoManu.Width - 5;
              if (img_Aviao.Tag >= 100) then
                begin
                  inc(Pontos, 500);
                  img_Aviao.Left  := -500;
                  img_Aviao.Tag   := 0;
                  Img_AviaoManu.Width := 100;
                end;
              AtualizaPontos;
            end;
        end;
    end;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel pelo 2� do disparo do jogador'}
procedure Tfrm_Protect.tmr_Disparo2Timer(Sender: TObject);
begin
  {Deslocamento do Disparo2 no eixo XY. Valor do deslocamento definido pelas
  Vari�veis PosX2 e PosY2 no evento OnKeyPress}
  img_Disparo2.Left := img_Disparo2.Left + PosX2;
  img_Disparo2.Top  := img_Disparo2.Top + PosY2;

  {Verica��o se a posi��o do Disparo2 est� entro dos valores definidos no
  onCreate do formul�rio}
  if ((Disparo2.X < 0) or
      (Disparo2.X > MAX_X) or
      (Disparo2.Y < 0)) Then
    begin
      tmr_Disparo2.Enabled := False;
      img_Disparo2.Visible := False;
    end
  else
    begin
      //Verificar se colide com a bomba
      if ((Disparo2.X > RectBomba.Left) and
          (Disparo2.X < RectBomba.Right) and
          (Disparo2.Y > RectBomba.Top) and
          (Disparo2.Y < RectBomba.Bottom)) Then
        begin
          if (tmr_Bomba.Enabled = True) then
            begin
              tmr_Bomba.Enabled     := false;
              tmr_Disparo2.Enabled   := false;
              img_Bomba.Visible     := false;
              img_Disparo2.Visible   := false;
              img_explosao.Left     := Bomba.X - (img_explosao.Width div 2);
              img_explosao.Top      := Bomba.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := True;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 10);
              AtualizaPontos;
            end;
        end
      else
        begin
          //Verificar se colide com o avi�o
          if ((Disparo2.X > RectAviao.Left) and
              (Disparo2.X < RectAviao.Right) and
              (Disparo2.Y > RectAviao.Top) and
              (Disparo2.Y < RectAviao.Bottom)) then
            begin
              tmr_Disparo2.Enabled   := False;
              img_Disparo2.Visible   := false;
              img_explosao.Left     := Disparo2.X - (img_explosao.Width div 2);
              img_explosao.Top      := Disparo2.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := true;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 50);
              img_Aviao.Tag := img_Aviao.Tag + 5;
              Img_AviaoManu.Width := Img_AviaoManu.Width - 5;
              if (img_Aviao.Tag >= 100) then
                begin
                  inc(Pontos, 500);
                  img_Aviao.Left  := -500;
                  img_Aviao.Tag   := 0;
                  Img_AviaoManu.Width := 100;
                end;
              AtualizaPontos;
            end;
        end;
    end;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel pelo 3� disparo do jogador'}
procedure Tfrm_Protect.tmr_Disparo3Timer(Sender: TObject);
begin
  {Deslocamento do Disparo3 no eixo XY. Valor do deslocamento definido pelas
  Vari�veis PosX3 e PosY3 no evento OnKeyPress}
  Img_Disparo3.Left := Img_Disparo3.Left + PosX3;
  Img_Disparo3.Top  := Img_Disparo3.Top + PosY3;

  {Verica��o se a posi��o do Disparo3 est� entro dos valores definidos no
  onCreate do formul�rio}
  if ((Disparo3.X < 0) or
      (Disparo3.X > MAX_X) or
      (Disparo3.Y < 0)) Then
    begin
      tmr_Disparo3.Enabled := False;
      Img_Disparo3.Visible := False;
    end
  else
    begin
      //Verificar se colide com a bomba
      if ((Disparo3.X > RectBomba.Left) and
          (Disparo3.X < RectBomba.Right) and
          (Disparo3.Y > RectBomba.Top) and
          (Disparo3.Y < RectBomba.Bottom)) then
        begin
          if (tmr_Bomba.Enabled = True) then
            begin
              tmr_Bomba.Enabled     := false;
              tmr_Disparo3.Enabled   := false;
              img_Bomba.Visible     := false;
              Img_Disparo3.Visible   := false;
              img_explosao.Left     := Bomba.X - (img_explosao.Width div 2);
              img_explosao.Top      := Bomba.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := True;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 10);
              AtualizaPontos;
            end;
        end
      else
        begin
          //Verificar se colide com o avi�o
          if ((Disparo3.X > RectAviao.Left) and
              (Disparo3.X < RectAviao.Right) and
              (Disparo3.Y > RectAviao.Top) and
              (Disparo3.Y < RectAviao.Bottom)) then
            begin
              tmr_Disparo3.Enabled   := False;
              Img_Disparo3.Visible   := false;
              img_explosao.Left     := Disparo3.X - (img_explosao.Width div 2);
              img_explosao.Top      := Disparo3.Y - (img_explosao.Height div 2);
              img_explosao.Visible  := true;
              tmr_Explosao.Enabled  := true;
              inc(Pontos, 50);
              img_Aviao.Tag := img_Aviao.Tag + 5;
              Img_AviaoManu.Width := Img_AviaoManu.Width - 5;
              if (img_Aviao.Tag >= 100) then
                begin
                  inc(Pontos, 500);
                  img_Aviao.Left  := -500;
                  img_Aviao.Tag   := 0;
                  Img_AviaoManu.Width := 100;
                end;
              AtualizaPontos;
            end;
        end;
    end;
end;
{$ENDREGION}

{$REGION 'Timer respons�vel por esconder a explos�o'}
procedure Tfrm_Protect.tmr_ExplosaoTimer(Sender: TObject);
begin
  img_explosao.Visible := False;
  tmr_Explosao.Enabled := false;
end;
{$ENDREGION}

end.
