unit Sceneloader;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Math, SysUtils, fpjson, jsonparser,
  raylib, Main;

procedure initLoader;
procedure initScene;
procedure unloadScene;
procedure loadJSON;
procedure computeScale(var target: TRenderTexture2D;var source, dest: TRectangle; var origin: TVector2);


type
  Scenes = (MainScene);

var
  Scene:                Scenes;
  SCREEN_WIDTH:         Integer;
  SCREEN_HEIGHT:        Integer;
  GameSCREEN_WIDTH:     Integer;
  GameSCREEN_HEIGHT:    Integer;

  setFLAGS:             Integer;
  scale:                Single;
  ExitWindow:           Boolean;
implementation

procedure initLoader;
var
//Window Scale
  target:           TRenderTexture2D;
  source, dest:     TRectangle;
  origin:           TVector2;
begin
  Scene := MainScene;

  loadJSON;
  SetConfigFlags(FLAG_WINDOW_RESIZABLE);
  SetConfigFlags(setFLAGS);
  InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Life');
  SetTargetFPS(10);
  SetWindowMinSize(640, 360);
  ExitWindow:=False;

  target:= LoadRenderTexture(GameSCREEN_WIDTH,GameSCREEN_HEIGHT);
  SetTextureFilter(target.texture,TEXTURE_FILTER_BILINEAR);
  SetExitKey(0);



  computeScale(target,source{%H-},dest{%H-},origin{%H-});
  initScene;

  while not ExitWindow do
  begin
  if (IsKeyPressed(KEY_ESCAPE) or WindowShouldClose) then ExitWindow:=True;
  if IsWindowResized then
  begin
    computeScale(target,source,dest,origin);
  end;

    case Scene of
      MainScene:              updateMain;
    end;

    BeginTextureMode(target);
    ClearBackground(BLACK);
    case Scene of
      MainScene:           drawMain;
    end;
    EndTextureMode;

    BeginDrawing;
    ClearBackground(BLACK);
     DrawTexturePro(target.texture,source, dest,origin,0.0,WHITE);
    EndDrawing;
  end;
  unloadScene;
  UnloadRenderTexture(target);
  CloseWindow;

end;

procedure initScene;
begin
  case Scene of
    MainScene:            initMain;
  end;
end;

procedure unloadScene;
begin
  case Scene of
    MainScene:            unloadMain;
  end;
end;

procedure loadJSON;
var
  JData:      TJSONData;
  JObj:       TJSONObject;
  filein:     TextFile;
  jsonString: String;
  line:       String;

  FLAGS:            Boolean;
begin

  jsonString:='';
  AssignFile(filein,'config.json');
  Reset(filein);


  while not EOF(filein) do
  begin
     ReadLn(filein, line);
     jsonString:= jsonString + line;
  end;
 Close(filein);

 JData:= GetJSON(jsonString);
 JObj:= JData as TJSONObject;


 SCREEN_WIDTH:= JObj{%H-}.Get('screen_width');
 SCREEN_HEIGHT:= JObj{%H-}.Get('screen_height');
 GameSCREEN_WIDTH:= JObj{%H-}.Get('gamescreen_width');
 GameSCREEN_HEIGHT:= JObj{%H-}.Get('gamescreen_height');

 FLAGS:= JObj{%H-}.Get('fullscreen');

 if FLAGS then
 begin
   setFLAGS:= FLAG_FULLSCREEN_MODE;
 end;


 JData.Free;
end;

procedure computeScale(var target: TRenderTexture2D; var source,
  dest: TRectangle; var origin: TVector2);
begin
  //computa a escala do framebuffer.
  scale:= Min(GetScreenWidth/GameSCREEN_WIDTH, GetScreenHeight/GameSCREEN_HEIGHT);

  with source do
  begin
    x:=0;
    y:=0;
    width:=   target.texture.width;
    height:= -target.texture.height;
  end;


  with dest do
  begin
   x:= (GetScreenWidth - GameSCREEN_WIDTH * scale)*0.5;
   y:= (GetScreenHeight - GameSCREEN_HEIGHT * scale)*0.5;
   width:=GameSCREEN_WIDTH*scale;
   height:=GameSCREEN_HEIGHT*scale;
  end;

  with origin do
  begin
   x:=0;
   y:=0;
  end;
end;

end.

