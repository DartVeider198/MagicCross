//Входной файл Cube.txt
//Выходной файл Solution.txt
//

program Cube;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  Square = record
             TopLeft: Byte;
             TopRigth: Byte;
             BottomLeft: Byte;
             BottomRight: Byte;
           end;

var
  MyFile, SolutionFile: TextFile;
  S: String;
  FirstMagicCross: array[1..12] of Square;
  MagicCross: array[1..12] of Square;
  i, j, z: Byte;
  BufferSquare: Square;

function GoodSquare(const Ai: Byte): Boolean;
begin
  Result := True;
  case Ai of
    2: Result := (MagicCross[1].TopRigth + MagicCross[2].TopLeft <= 10);

    4: Result := (MagicCross[1].BottomLeft + MagicCross[3].TopRigth + MagicCross[4].TopLeft <= 10);

    5: Result := (MagicCross[1].BottomRight + MagicCross[2].BottomLeft + MagicCross[4].TopRigth + MagicCross[5].TopLeft = 10);

    6: Result := (MagicCross[2].BottomRight + MagicCross[5].TopRigth + MagicCross[6].TopLeft <= 10);

    7: Result := (MagicCross[3].BottomLeft + MagicCross[7].TopLeft <= 10);

    8: Result := (MagicCross[3].BottomRight + MagicCross[4].BottomLeft + MagicCross[7].TopRigth + MagicCross[8].TopLeft = 10);

    9: Result := (MagicCross[4].BottomRight + MagicCross[5].BottomLeft + MagicCross[8].TopRigth + MagicCross[9].TopLeft = 10);

    10: Result := (MagicCross[6].BottomRight + MagicCross[10].TopRigth <= 10) and
                  (MagicCross[5].BottomRight + MagicCross[6].BottomLeft + MagicCross[9].TopRigth + MagicCross[10].TopLeft = 10);

    11: Result := (MagicCross[7].BottomRight + MagicCross[8].BottomLeft + MagicCross[11].TopLeft <= 10);

    12: Result := (MagicCross[11].BottomRight + MagicCross[12].BottomLeft <= 10) and
                  (MagicCross[9].BottomRight + MagicCross[10].BottomLeft + MagicCross[12].TopRigth <= 10) and
                  (MagicCross[8].BottomRight + MagicCross[9].BottomLeft + MagicCross[11].TopRigth + MagicCross[12].TopLeft = 10);
  end;
end;

procedure ChangeSquare(const A, B: Byte);
var
  C: Square;
begin
  C := MagicCross[A];
  MagicCross[A] := MagicCross[B];
  MagicCross[B] := C;
end;

procedure CheckMagicCross(const Ai: Byte);
var
  i: Byte;
  S: string;
  B: Boolean;
begin
  if not GoodSquare(Ai) then
    Exit;
  B := False;
  if Ai = 12 then
  begin
    Reset(SolutionFile);
    while not Eof(SolutionFile) do
    begin
      B:= True;
      for i := 1 to 12 do
      begin
        ReadLn(SolutionFile, S);
        if S <> IntToStr(MagicCross[i].TopLeft) + ' ' +
                IntToStr(MagicCross[i].TopRigth) + ' ' +
                IntToStr(MagicCross[i].BottomLeft) + ' ' +
                IntToStr(MagicCross[i].BottomRight) then
          B := False;
      end;
      ReadLn(SolutionFile, S);
      if B then
        Break;
    end;
    CloseFile(SolutionFile);
    if not B then
    begin
      Append(SolutionFile);
      for i := 1 to 12 do
      begin
        Write(SolutionFile, IntToStr(MagicCross[i].TopLeft) + ' ' +
                            IntToStr(MagicCross[i].TopRigth) + ' ' +
                            IntToStr(MagicCross[i].BottomLeft) + ' ' +
                            IntToStr(MagicCross[i].BottomRight));
        Write(SolutionFile, #13#10);
      end;
      Write(SolutionFile, #13#10);
      CloseFile(SolutionFile);
    end;
    Exit;
  end;

  for i := Ai + 1 to 12 do
  begin
    ChangeSquare(Ai + 1, i);
    CheckMagicCross(Ai + 1);
    ChangeSquare(Ai + 1, i);
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    AssignFile(MyFile, 'Cube.txt');
    AssignFile(SolutionFile, 'Solution.txt');
    Rewrite(SolutionFile);
    CloseFile(SolutionFile);
    Reset(MyFile);

    WriteLn('Строки, прочитанные из файла:');
    WriteLn;
    For i := 1 to 12 do
    begin
      ReadLn(MyFile, S);
      MagicCross[i].TopLeft := StrToInt(Copy(S, 1, 1));
      MagicCross[i].TopRigth := StrToInt(Copy(S, 3, 1));
      MagicCross[i].BottomLeft := StrToInt(Copy(S, 5, 1));
      MagicCross[i].BottomRight := StrToInt(Copy(S, 7, 1));
      WriteLn(S);
    end;
    CloseFile(MyFile);

    for i := 1 to 12 do
      FirstMagicCross[i] := MagicCross[i];

    for i := 1 to 12 do
    begin
      CheckMagicCross(1);

      for z := 1 to 12 do
        MagicCross[z] := FirstMagicCross[z];

      BufferSquare := MagicCross[1];
      for j := 2 to 12 do
        MagicCross[j - 1] := MagicCross[j];

      MagicCross[12] := BufferSquare;
    end;


    WriteLn;
    WriteLn('Решение выведено в Solution.txt');

    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
