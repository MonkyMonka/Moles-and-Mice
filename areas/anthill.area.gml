//Development Area, set the DEBUG Macro to true to access

#define init

//Sprites
global.sprAreaIcon = sprite_add("../sprites/areas/devzone/sprAreaIconDevzone.png",1,4,4);
global.sprFloor = sprite_add("../sprites/areas/devzone/sprFloorDevzone.png",1,0,0);
global.sprFloorB = sprite_add("../sprites/areas/devzone/sprFloorDevzoneB.png",1,0,0);
global.sprFloorExplo = sprite_add("../sprites/areas/devzone/sprFloorDevzoneExplo.png",4,1,1);
global.sprWallBot = sprite_add("../sprites/areas/devzone/sprWallDevzoneBot.png",3,0,0);
global.sprWallTop = sprite_add("../sprites/areas/devzone/sprWallDevzoneTop.png",1,0,0);
global.sprWallOut = sprite_add("../sprites/areas/devzone/sprWallDevzoneOut.png",1,4,12);
global.sprWallTrans = sprite_add("../sprites/areas/devzone/sprWallDevzoneTrans.png",1,0,0);
global.sprDebris = sprite_add("../sprites/areas/devzone/sprDebrisDevzone.png",4,4,4);
global.sprDetail = sprite_add("../sprites/areas/devzone/sprDetailDevzone.png",6,4,4);
//global.sprTopDecal = sprite_add("sprites/areas/devzone/sprDevzoneTopDecal.png",3,16,24);


 // Number of subareas:
#macro subareas                 1
 // The area after this one:
#macro nextarea                 1
#macro nsubarea                 1

#macro area_backcol             make_color_rgb(65,83,124)

#macro DEBUG true// remember to set to false before sharing

    if DEBUG{
        trace("Press 6 to access CORN area");
        if fork(){
            while(mod_exists("area", mod_current)){
                with(Player) if button_pressed(index, "key6"){
                    with instance_create(x, y, Portal) endgame = 5;
                    with(GameCont){
                        area = mod_current;
                        subarea = 0;
                    }
                }
                wait(0);
            }
            exit;
        }
    }
#define area_name
return "CORN";

#define area_text
	return choose(
		"@(color:16745694)MAKE SOMETHING NEAT",
		"@(color:16745694)THIS IS WHERE BRAIN WORK",
		"@(color:16745694)BE SMARTERER", 
		"@(color:16745694)DONT CRASH IT THIS TIME",
		"@(color:16745694)OOPS! ANOTHER ERROR!"
	);

#define area_sprite(q)
switch (q) {
    case sprFloor1:   with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return global.sprFloor;
    case sprFloor1B:  with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return global.sprFloorB;
    case sprFloor1Explo: return global.sprFloorExplo;
    case sprWall1Trans: return global.sprWallTrans;
    case sprWall1Bot: return global.sprWallBot;
    case sprWall1Out: return global.sprWallOut;
    case sprWall1Top: return global.sprWallTop;
    case sprDebris1: return global.sprDebris;
	case sprDetail1: return global.sprDetail;
}
#define area_setup_floor
//Footsteps
material = 3;

#define area_setup
    sound_play_music(musThemeP)
    sound_play_ambient(amb6);
    goal = 110;
    background_color = area_backcol;
    BackCont.shadcol = c_black;
    TopCont.darkness = 0; //if area is dark
    GameCont.norads = 0; // disable horror spawn when debugging
    safespawn = 1;
   
    
#define area_start
//Laser Traps
//	with Floor
//	if !place_meeting(x,y,Player) and !place_meeting(x,y,enemy) and !place_meeting(x,y,RadChest) and !place_meeting(x,y,AmmoChest) and !place_meeting(x,y,WeaponChest) and !place_meeting(x,y,prop){
//	if random(30) < 1 and !place_meeting(x,y,NOWALLSHEREPLEASE){ //this random is chance to spawn traps
//		var myx = x+choose(0,16);
//		var myy = y+choose(0,16);
		
//		with instance_create(myx,myy,Wall)
//			instance_create(x,y,NOWALLSHEREPLEASE)
//		if point_distance(myx,myy,Player.x,Player.y) > 90
//		mod_script_call("mod", "LaserTrap", "LaserTrap_create", myx + 8,myy + 8);
//		}
//	}
	
#define area_make_floor
var turn = choose(0,0,0,0,0,0,0,0,0,90,90,90,-90,180);
direction += turn;

//weapon chest spawn
if (turn == 180 && point_distance(x, y, 10016, 10016) > 48) {
    instance_create(x, y, Floor);
    instance_create(x + 16, y + 16, WeaponChest);}
//ammo chest spawn
if (turn == -90 && point_distance(x, y, 10016, 10016) > 48) {
    instance_create(x, y, Floor);
    instance_create(x + 16, y + 16, AmmoChest);}
    
//Area Generation
if abs(turn) = 90 and random(4) < 1{
	instance_create(x+32,y,Floor)
	instance_create(x+32,y+32,Floor)
	instance_create(x,y+32,Floor)
	instance_create(x,y-32,Floor)
	instance_create(x-32,y,Floor)
	instance_create(x+32,y-32,Floor)
	instance_create(x-32,y-32,Floor)
	instance_create(x-32,y+32,Floor)
	}
else instance_create(x,y,Floor)

if random(20) < 1
	instance_create(x,y,FloorMaker)

	
#define area_finish
    lastarea = area;
    subarea++;
    
    if background_color == area_backcol && subarea > subareas{
        area =      nextarea;
        subarea =   nsubarea;
    }

#define area_secret
    return true;
    
#define area_mapdata(lx, ly, lp, ls, ws, ll)
    return [lx, -9,10,1,1];