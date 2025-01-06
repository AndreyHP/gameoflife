unit Main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

procedure initMain;
procedure updateMain;
procedure drawMain;
procedure unloadMain;
function CountNeighbors(x,y: Integer): Integer;
procedure UpdateGrid;

implementation

uses
  Sceneloader, raylib;

const
  SIZE_X = 53;
  SIZE_Y = 30;

type
  TCell = record
    alive: Boolean;
    posX:  Integer;
    posY:  Integer;
    count: Integer;
    id:    Integer;
  end;

var
  x: Integer;
  y: Integer;
  cells: array[1..SIZE_X, 1..SIZE_Y] of TCell;
  newGrid: array[1..SIZE_X, 1..SIZE_Y] of TCell;

procedure initMain;
var
  randomNumber: Integer;
begin

  Randomize;

  for x:= 1 to SIZE_X do
     for y:= 1 to SIZE_Y do
     begin

        randomNumber:= Random(2) + 1;

        if randomNumber >= 2 then
        begin
          cells[x,1].alive:= True;
          cells[1,y].alive:= True;
        end
        else
        begin
           cells[x,1].alive:= False;
           cells[1,y].alive:= False;
        end;
  end;

end;

procedure updateMain;
var
  randomNumber: Integer;
begin

  if IsKeyPressed(KEY_SPACE) then
  begin

  Randomize;

  for x:= 1 to SIZE_X do
     for y:= 1 to SIZE_Y do
     begin

        randomNumber:= Random(2) + 1;


        if randomNumber >= 2 then
        begin
          cells[x,1].alive:= True;
          cells[1,y].alive:= True;
        end
        else
        begin
           cells[x,1].alive:=False;
           cells[1,y].alive:=False;
        end;
     end;
  end;

  UpdateGrid;
end;

procedure drawMain;
begin
   for x:= 1 to SIZE_X do
     for y:= 1 to SIZE_Y do
     begin
       if cells[x,y].alive = True then
       begin
        DrawCircle(x * 35,y * 35,11.0,RED);
       end;

       // DrawCircle(x * 35,y * 35,11.0,RED);
     end;


end;

procedure unloadMain;
begin

end;

function CountNeighbors(x,y: Integer): Integer;
var
  dx, dy: Integer;
  count: Integer;
begin
  count := 0;
  for dx := -1 to 1 do
    for dy := -1 to 1 do
      if (dx <> 0) or (dy <> 0) then
      begin
        if (x + dx >= 0) and (x + dx < SIZE_X) and
           (y + dy >= 0) and (y + dy < SIZE_Y) then
        begin
          if cells[x + dx, y + dy].alive then
            Inc(count);
        end;
      end;
  Result := count;
end;

procedure UpdateGrid;
begin
  for x := 0 to SIZE_X do
    for y := 0 to SIZE_Y do
    begin
      newGrid[x, y] := cells[x, y]; // Copy current state
      case CountNeighbors(x, y) of
        1: newGrid[x, y].alive := False;
        2: ; // Stay the same
        3: newGrid[x, y].alive := True; // Birth
        else newGrid[x, y].alive := False; // Death
      end;
    end;
  cells := newGrid; // Update the grid
end;

end.


