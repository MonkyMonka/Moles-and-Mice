 // On Mod Load:
#define init
	global.newLevel = instance_exists(GenCont);

	/// Define Sprites : sprite_add("path/to/sprite/starting/from/mod/location.png", frames, x-offset, y-offset) \\\
	 // A-Skin:
	global.spr_idle[0] = sprite_add("../sprites/areassprMutant1Idle.png",	4, 12, 12);
	global.spr_walk[0] = sprite_add("../sprites/areassprMutant1Walk.png",	6, 12, 12);
	global.spr_hurt[0] = sprite_add("../sprites/areassprMutant1Hurt.png",	3, 12, 12);
	global.spr_dead[0] = sprite_add("../sprites/areassprMutant1Dead.png",	6, 12, 12);
	global.spr_sit1[0] = sprite_add("../sprites/areassprMutant1GoSit.png",	3, 12, 12);
	global.spr_sit2[0] = sprite_add("../sprites/areassprMutant1Sit.png",	1, 12, 12);

	 // B-Skin:
	global.spr_idle[1] = sprite_add("../sprites/areassprMutant1BIdle.png",	4, 12, 12);
	global.spr_walk[1] = sprite_add("../sprites/areassprMutant1BWalk.png",	6, 12, 12);
	global.spr_hurt[1] = sprite_add("../sprites/areassprMutant1BHurt.png",	3, 12, 12);
	global.spr_dead[1] = sprite_add("../sprites/areassprMutant1BDead.png",	6, 12, 12);
	global.spr_sit1[1] = sprite_add("../sprites/areassprMutant1BGoSit.png",	3, 12, 12);
	global.spr_sit2[1] = sprite_add("../sprites/areassprMutant1BSit.png",	1, 12, 12);
	
	 // Character Selection / Loading Screen:
	global.spr_slct = sprite_add("../sprites/areassprCharSelect.png",	1,				0,  0);
	global.spr_port = sprite_add("../sprites/areassprBigPortrait.png",	race_skins(),	40, 243);
	global.spr_skin = sprite_add("../sprites/areassprLoadoutSkin.png",	race_skins(),	16, 16);
	global.spr_icon = sprite_add("../sprites/areassprMapIcon.png",		race_skins(),	10, 10);

	 // Ultras:
	global.spr_ult_slct = sprite_add("../sprites/areassprEGSkillIcon.png",	ultra_count("fishexample"), 12, 16);
	global.spr_ult_icon[1] = sprite_add("../sprites/areassprEGIconHUDA.png", 1, 8, 9);
	global.spr_ult_icon[2] = sprite_add("../sprites/areassprEGIconHUDB.png", 1, 8, 9);


	var _race = [];
	for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
	while(true){
		/// Character Selection Sound:
		for(var i = 0; i < maxp; i++){
			var r = player_get_race(i);
			if(_race[i] != r && r = "fishexample"){
				sound_play(sndMutant1Slct); // Select Sound
			}
			_race[i] = r;
		}

		/// Call level_start At The Start Of Every Level:
		if(instance_exists(GenCont)) global.newLevel = 1;
		else if(global.newLevel){
			global.newLevel = 0;
			level_start();
		}
		wait 1;
	}


 // On Level Start: (Custom Script, Look Above In #define init)
#define level_start
	///  ULTRA B : Gun Warrant  \\\
	if(ultra_get("fishexample", 2)) with instances_matching(Player, "race", "fishexample"){
		infammo = 210; // 7 Seconds of Infinite Ammo
	}


 // On Run Start:
#define game_start
	sound_play(sndMutant1Cnfm); // Play Confirm Sound


 // On Character's Creation (Starting a run, getting revived in co-op, etc.):
#define create
	rollTime = 0; // Rolling Time Variable

	/// PASSIVE : More Ammo \\\
	typ_ammo[1] = 40;	// +8 Bullets
	typ_ammo[2] = 10;	// +2 Shells
	typ_ammo[3] = 9;	// +2 Bolts
	typ_ammo[4] = 8;	// +2 Explosives
	typ_ammo[5] = 13;	// +3 Energy

	 // Set Sprites:
	spr_idle = global.spr_idle[bskin];
	spr_walk = global.spr_walk[bskin];
	spr_hurt = global.spr_hurt[bskin];
	spr_dead = global.spr_dead[bskin];
	spr_sit1 = global.spr_sit1[bskin];
	spr_sit2 = global.spr_sit2[bskin];

	 // Set Sounds:
	snd_wrld = sndMutant1Wrld;	// FLÄSHYN
	snd_hurt = sndMutant1Hurt;	// THE WIND HURTS
	snd_dead = sndMutant1Dead;	// THE STRUGGLE CONTINUES
	snd_lowa = sndMutant1LowA;	// ALWAYS KEEP ONE EYE ON YOUR AMMO
	snd_lowh = sndMutant1LowH;	// THIS ISN'T GOING TO END WELL
	snd_chst = sndMutant1Chst;	// TRY NOT OPENING WEAPON CHESTS
	snd_valt = sndMutant1Valt;	// AWWW YES
	snd_crwn = sndMutant1Crwn;	// CROWNS ARE LOYAL
	snd_spch = sndMutant1Spch;	// YOU REACHED THE NUCLEAR THRONE
	snd_idpd = sndMutant1IDPD;	// BEYOND THE PORTAL
	snd_cptn = sndMutant1Cptn;	// THE STRUGGLE IS OVER


 // Every Frame While Character Exists:
#define step
	///  ACTIVE : Roll  \\\
	if(canspec){
		 // Roll Towards Mouse If Not Moving:
		if(button_pressed(index, "spec") && speed <= 0) direction = gunangle;

		 // Start Water Boost:
		if(skill_get(5)){
			 // Sound:
			if(button_pressed(index, "spec")){
				sound_play(sndFishRollUpg);
				sound_loop(sndFishTB);
			}

			 // Boost:
			if(button_check(index, "spec")) rollTime = 2;
		}

		 // Start Roll:
		else if(button_pressed(index, "spec") && !rollTime){
			rollTime = 10;		 // 10 Frame Roll
			sound_play(sndRoll); // Sound
			
		}
	}
	if(rollTime > 0){
		rollTime--;

		 // Speedify:
		speed = maxspeed + 2;

		/// Throne Butt \\\
		if(skill_get(5)){
			sprite_angle = direction - 90;	// Point Towards Direction
			instance_create(x,y,FishBoost);	// Water Particles
		}

		/// Roll (No Butt) \\\
		else{
			canwalk = 0;				// Can't Use Movement Keys
			sprite_angle += 40 * right;	// Rotate
			instance_create(x + random_range(-3, 3), y + random(6), Dust); // Dust Particles:
		}

		 // Bounce Off Walls:
		if(place_meeting(x + hspeed, y + vspeed, Wall)){
			move_bounce_solid(true);
			rollTime *= skill_get(5);
		}

		 // On Roll End:
		if(rollTime <= 0){
			sprite_angle = 0;		// Reset Rotation
			canwalk = 1;			// Can Use Movement Keys Again
			sound_stop(sndFishTB);	// Stop Water Boost Sound
		}
	}

	///  ULTRA A : Confiscate  \\\
	if(ultra_get("fishexample", 1)){
		 // 20% of Pickups Turn Into Their Respective Chests:
		with instances_matching(Pickup, "object_index", AmmoPickup, HPPickup, WepPickup) if("confiscateChance" not in self){
			confiscateChance = 20;
			with instances_matching(ChestOpen, "pickupCheck", undefined){
				pickupCheck = 1;
				if(place_meeting(x,y,other)) other.confiscateChance = 0;
			}
			if(random(100) < confiscateChance){
				switch(object_index){
					case AmmoPickup: instance_create(x, y, AmmoChest);	 break;
					case HPPickup:	 instance_create(x, y, HealthChest); break;
					case WepPickup:	 instance_create(x, y, WeaponChest); break;
				}
				instance_delete(id);
			}
		}

		 // Confiscate Effect:
		with(enemy) if(my_health <= 0) instance_create(x, y, FishA);
	}


 // Name:
#define race_name
	return "FISH";


 // Description:
#define race_text
	return "GETS MORE @yAMMO#@wCAN ROLL";


 // Starting Weapon:
#define race_swep
	return 1; // Revolver


 // Throne Butt Description:
#define race_tb_text
	return "WATER BOOST";


 // On Taking Throne Butt:
#define race_tb_take


 // Character Selection Icon:
#define race_menu_button
	sprite_index = global.spr_slct;


 // Portrait:
#define race_portrait
	return global.spr_port;


 // Loading Screen Map Icon:
#define race_mapicon
	return global.spr_icon;


 // Skin Count:
#define race_skins
	return 2; // 2 Skins, A + B


 // Skin Icons:
#define race_skin_button
	sprite_index = global.spr_skin;
	image_index = argument0;


 // Ultra Names:
#define race_ultra_name
	switch(argument0){
		case 1: return "CONFISCATE";
		case 2: return "GUN WARRANT";
		/// Add more cases if you have more ultras!
	}


 // Ultra Descriptions:
#define race_ultra_text
	switch(argument0){
		case 1: return "@wENEMIES @sSOMETIMES DROP @wCHESTS";
		case 2: return "@yINFINITE AMMO @sTHE FIRST 7 SECONDS#AFTER EXITING A @pPORTAL";
		/// Add more cases if you have more ultras!
	}


 // On Taking An Ultra:
#define race_ultra_take
	if(instance_exists(mutbutton)) switch(argument0){
		 // Play Ultra Sounds:
		case 1:	sound_play(sndFishUltraA); break;
		case 2: sound_play(sndFishUltraB); break;
		/// Add more cases if you have more ultras!
	}


 // Ultra Button Portraits:
#define race_ultra_button
	sprite_index = global.spr_ult_slct;
	image_index = argument0 + 1;


 // Ultra HUD Icons:
#define race_ultra_icon
	return global.spr_ult_icon[argument0];


 // Loading Screen Tips:
#define race_ttip
	return ["THE TASTE OF MUD", "LIKE KEVIN COSTNER", "GILLS ON YOUR NECK", "IT'S OK TO EAT", "DUTY CALLS", "LAST DAY BEFORE RETIREMENT"];