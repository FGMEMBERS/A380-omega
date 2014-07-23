# (Airbus A380) E/WD - Engine and Warnings Display
# Narendran M (c) 2014

var placement = "ecam_ewd";

var ewd_pages = {};

ewd_pages["start"] = {
	path: "/Aircraft/A380/Models/Instruments/EWD/ecam_ewd.svg",
	svg: {},
	objects: ["eng1_off", "eng2_off", "eng3_off", "eng4_off", "eng1_fwd", "eng2_fwd", "eng3_fwd", "eng4_fwd", "eng1_rev", "eng2_rev", "eng3_rev", "eng4_rev", "egt1", "egt2", "egt3", "egt4", "egt1_text", "egt2_text", "egt3_text", "egt4_text", "egt1_off", "egt2_off", "egt3_off", "egt4_off", "egt1_needle", "egt2_needle", "egt3_needle", "egt4_needle", "eng1_thrlever", "eng2_thrlever", "eng3_thrlever", "eng4_thrlever", "eng1_thrneedle", "eng2_thrneedle", "eng3_thrneedle", "eng4_thrneedle", "eng1_thrtext", "eng2_thrtext", "eng3_thrtext", "eng4_thrtext", "packs_nai", "packs_nai"],
	eng_x: [0, 93, 271, 525, 703],
	egt_x: [0, 100, 278, 532, 710],
	update: func {
		# Engine Status
		for(var n=1; n<=4; n=n+1) {
			var n1 = getprop("/engines/engine["~(n-1)~"]/n1");
			var n2 = getprop("/engines/engine["~(n-1)~"]/n2");
			var egt = (getprop("/engines/engine["~(n-1)~"]/egt-degf")-32)*(5/9);
			var reversed = getprop("/engines/engine["~(n-1)~"]/reversed");
			var lvr = getprop("/controls/engines/engine["~(n-1)~"]/throttle");
			var thr = (n2-58)*(100/42);
			if(thr < 0) {
				thr = 0;
			}
			
			if(n2 > 25) { # Engine Started
				if(reversed) { # Reverse Thrust Engaged
					me.svg["eng"~n~"_off"].hide();
					me.svg["eng"~n~"_rev"].show();
					me.svg["eng"~n~"_fwd"].hide();
					me.svg["egt"~n~"_off"].hide();
					me.svg["egt"~n].show();
					me.svg["eng"~n~"_thrlever"].show().setCenter(me.eng_x[n], 1050-890).setRotation(-lvr*110*D2R);
					me.svg["eng"~n~"_thrneedle"].show().setCenter(me.eng_x[n], 1050-890).setRotation(-thr*1.1*D2R);
					me.svg["eng"~n~"_thrtext"].hide();
					me.svg["egt"~n~"_needle"].show().setCenter(me.egt_x[n], 1050-697).setRotation(egt*(180/870)*D2R);
					me.svg["egt"~n~"_text"].show().setText(sprintf("%4.0f", egt));
				} else { # Reverse Thrust Disengaged
					me.svg["eng"~n~"_off"].hide();
					me.svg["eng"~n~"_rev"].hide();
					me.svg["eng"~n~"_fwd"].show();
					me.svg["egt"~n~"_off"].hide();
					me.svg["egt"~n].show();
					me.svg["eng"~n~"_thrlever"].show().setCenter(me.eng_x[n], 1050-890).setRotation(lvr*210*D2R);
					me.svg["eng"~n~"_thrneedle"].show().setCenter(me.eng_x[n], 1050-890).setRotation(thr*2.1*D2R);
					me.svg["eng"~n~"_thrtext"].show().setText(sprintf("%3.1f", thr));
					me.svg["egt"~n~"_needle"].show().setCenter(me.egt_x[n], 1050-697).setRotation(egt*(180/870)*D2R);
					me.svg["egt"~n~"_text"].show().setText(sprintf("%4.0f", egt));
				}
			} else { # Engine turned off
				me.svg["eng"~n~"_off"].show();
				me.svg["eng"~n~"_rev"].hide();
				me.svg["eng"~n~"_fwd"].hide();
				me.svg["egt"~n~"_off"].show();
				me.svg["egt"~n].hide();
				me.svg["eng"~n~"_thrlever"].hide();
				me.svg["eng"~n~"_thrneedle"].hide();
				me.svg["eng"~n~"_thrtext"].hide();
				me.svg["egt"~n~"_needle"].hide();
				me.svg["egt"~n~"_text"].hide();
			}
		}
	}
};

var ewd = ecam.new(ewd_pages, placement);

setlistener("sim/signals/fdm-initialized", func {
	ewd.init();
	print("Engine and Warnings Display Initialized");
});
