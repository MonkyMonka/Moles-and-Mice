#define init
    global.spr = {
        WeaponSprite: sprite_add_weapon("../sprites/weapons/CarrionSprites/CarrionHand.png", 0, 4),
        Maggotball: sprite_add("../sprites/weapons/CarrionSprites/Maggotball.png", 1, 0, 0),
        NestMaggotIdle:sprite_add("../sprites/weapons/CarrionSprites/sprNestMaggotIdle.png", 4, 8, 8),
        NestMaggotHurt:sprite_add("../sprites/weapons/CarrionSprites/sprNestMaggotHurt.png", 3, 8, 8),
        NestMaggotDeath:sprite_add("../sprites/weapons/CarrionSprites/sprNestMaggotDeath.png", 6, 8, 8), }
    global.msk = {
    	Maggotball:	sprite_add("../sprites/weapons/CarrionSprites/mskMaggotball.png", 1, 1, 1),
    	NestMaggot: sprite_add("../sprites/weapons/CarrionSprites/mskNestMaggot.png", 1, 0, 0),
    }

#define weapon_name  
    return "CARRION HAND";      
#define weapon_type  
    return 4;
#define weapon_area  
    return 1;
#define weapon_auto  
    return 0;
#define weapon_cost  
    return 2;
#define weapon_load  
    return 8;
#define weapon_swap 
    return sndSwapMotorized;
#define weapon_sprt  
    return global.spr.WeaponSprite;
#define weapon_text  
    return "THE CIRCLE OF LIFE";
#define weapon_melee 
    return 0;
#define nts_weapon_examine  
    return{ "d": "A NEST OF MAGGOTS",}
#define weapon_fire
	var c = (instance_is(self, FireCont) && "creator" in self) ? creator : self;
	var _gunangle = "gunangle" in self ? gunangle : direction;
    var _accuracy = "accuracy" in self ? accuracy : 1;
	with(instance_create(x,y,CustomProjectile)) {
    	creator = c;
    	team = other.team;
    	speed = random_range(8,10); 
    	friction = 0;
		direction = creator.gunangle + random_range(-5,5);
		image_angle = direction;
		sprite_index = global.spr.Maggotball ;
		mask_index = global.msk.Maggotball;
		damage = 3;
		force = 3;
		image_xscale = 1;
		image_yscale = 1;
		alrm0 = 10;
		alrm0_max = 30;
		ammo = 5
		on_destroy = generic_destroy;
		on_step = generic_step
	 }
#define generic_step
    if (alrm0){
        alrm0 -= current_time_scale;
        if alrm0 <= 0{
            with(CustomMaggot_Create(x, y)){
                direction = random(360);
                speed = 100;
                team = other.team;
            }
            ammo --;
            if ammo <= 0{
                instance_destroy();
                exit;
            }
            alrm0 = 10 + random(10);
        }
    }
    
#define generic_destroy
    repeat(3){
        with(instance_create(x + random_range(-1,1),y + random_range(-1,1),MeatExplosion)){
            team = other.team;
        }
    }
    if ammo > 0{
        repeat(ammo){
            with(CustomMaggot_Create(x, y)){
                direction = random(360);
                speed = 14;
                team = other.team;
            }
        }
    }
    sound_play(sndMeatExplo);
	
#define CustomMaggot_Create(_x, _y)
    with(instance_create(_x, _y,CustomProjectile)){
        sprite_index = global.spr.NestMaggotIdle;
        on_destroy = maggotshot_destroy;
    
        return self;
    }
#define maggotshot_destroy
	with(instance_create(x,y,CustomHitme)){
		team = other.team;
		creator = other.creator;
		spr_idle = global.spr.NestMaggotIdle;
		spr_walk = global.spr.NestMaggotIdle;
		spr_hurt = global.spr.NestMaggotHurt;
		spr_dead = global.spr.NestMaggotDeath;
		
		sprite_index = spr_idle;
		my_health = 4;
		maxhealth = 4;
		image_speed = 0.4;
		
	
		alrm0 = 10;
		alrm0_max = 30;
		meleedamage = 1;
		death = 10;
		
		mommy_range = 72;
		canmelee = current_frame;
		on_hurt = custommaggot_hurt;
		on_step = custommaggot_step;
	
		return self;
	}
#define custommaggot_hurt
	my_health -= argument0;
	sprite_index = spr_hurt;
	image_index = 1;
#define custommaggot_step
	// Kills it, because CustomHitme can't kill themselves
	if my_health <= 0{
		with(instance_create(x,y,Corpse)){
			sprite_index = other.spr_dead;
			sound_play(other.snd_dead);
		}
		instance_destroy();
		exit;
	}
	// Resets the sprite
	if image_index + image_speed >= image_number{
		sprite_index = spr_idle;
		image_index = 0;
	}
	// Bouncy offa da walls
	if place_meeting(x,y,Wall){
		move_bounce_solid(true);
		x = xprevious;
		y = yprevious;
	}
	// Behavioral timer
	if (alrm0 > 0){
		alrm0 -= current_time_scale;
		if alrm0 <= 0{
			death --;
			if death <= 0{
				my_health = 0;
				exit;
			}
			image_xscale = (direction + 270) % 360 > 180 ? -1 : 1;
			// Attack the nearest enemy, or randomly bumble about if none are found
			var _n = instance_nearest(x,y,enemy);
			if instance_exists(_n) && !collision_line(_n.x,_n.y,x,y, Wall, 0, 1){
				direction = point_direction(x,y,_n.y,_n.y) + random_range(-20,20);
				speed = 3;
			}else{
				speed = 1;
				direction = random(360);
			}
			/*
			// Makes them go back to the creator instead
			if instance_exists(creator){
				if distance_to_object(creator) > mommy_range{
					direction = point_direction(x,y,creator.x,creator.y) + random_range(-10,10);
					speed = 2;
				}else{
					direction = random(360);
					speed = 1.5;
				}
			}
			*/
			alrm0 = alrm0_max + random_range(-15,5);
		}
	}
	// Hurts the enemies
	if (canmelee <= current_frame){
		with(instances_meeting(x,y,enemy, 0)){
			projectile_hit(self, other.meleedamage);
			other.canmelee = current_frame + 5;
			other.speed = 1;
			other.direction += 180 + random_range(-30,30);
			projectile_hit(other, 1);
			break;
		}
	}
#define instances_meeting(_x, _y, _obj, prec)
    /*
        Returns all instances whose bounding boxes overlap the calling instance's bounding box at the given position
        Much better performance than manually performing 'place_meeting(x, y, other)' on every instance
    */
    
    var _tx = x,
        _ty = y;
        
    x = _x;
    y = _y;
    
	var _inst = [];
    if !(prec){
		_inst = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
	}else{
		with(instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id)){
			if place_meeting(x, y, other){
				_inst[array_length(_inst)] = id;
			}
		}
	}
    
    x = _tx;
    y = _ty;
    
    return _inst;