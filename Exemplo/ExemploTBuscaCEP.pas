unit ExemploTBuscaCEP;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, BuscaCEP, FMX.ListBox;

type
  TForm1 = class(TForm)
    BuscaCEP: TBuscaCEP;
    Button1: TButton;
    Label1: TLabel;
    edtCEP: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtLogradouro: TEdit;
    edtComlemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    edtUnidade: TEdit;
    edtIBGE: TEdit;
    edtGIA: TEdit;
    Label2: TLabel;
    cbbServidor: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    procedure LimparResultados;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  BuscaCEP.Servidor := TServidor(Integer(cbbServidor.ItemIndex));
  if BuscaCEP.Buscar(edtCEP.Text) then
  begin
    edtLogradouro.Text := BuscaCEP.Logradouro;
    edtComlemento.Text := BuscaCEP.Complemento;
    edtBairro.Text     := BuscaCEP.Bairro;
    edtCidade.Text     := BuscaCEP.Localidade;
    edtUF.Text         := BuscaCEP.UF;
    edtUnidade.Text    := BuscaCEP.Unidade;
    edtIBGE.Text       := BuscaCEP.IBGE;
    edtGIA.Text        := BuscaCEP.GIA;
  end;
end;

procedure TForm1.LimparResultados;
begin
  edtLogradouro.Text := '';
  edtComlemento.Text := '';
  edtBairro.Text     := '';
  edtCidade.Text     := '';
  edtUF.Text         := '';
  edtUnidade.Text    := '';
  edtIBGE.Text       := '';
  edtGIA.Text        := '';
end;

end.
