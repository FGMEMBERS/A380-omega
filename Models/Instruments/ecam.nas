# (Airbus A380) Electronic Centralized Aircraft Monitor
# Narendran M (c) 2014

var ecam = {
	active: "",
	pages: {},
	new: func(pages, placement) {
		var t = {parents:[ecam]};
		t.pages = pages;
		
		t.display = canvas.new({
			"name":			"ECAM Display",
			"size":			[800, 1024],
			"view":			[800, 1024],
			"mipmapping":	1
		});
		
		t.display.addPlacement({"node": placement});
		t.objects = t.display.createGroup();
		t.timer = maketimer(0.05, t, t.update);
		
		t.load("start");
		
		return t;
	},
	load: func(page) {
		me.objects.removeAllChildren();
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		canvas.parsesvg(me.objects, me.pages[page].path, {'font-mapper': font_mapper});
		# Cache SVG Objects for animation
		foreach(var svg_object; me.pages[page].objects) {
			me.pages[page].svg[svg_object] = me.objects.getElementById(svg_object);
		}
		me.active = page;
	},
	update: func() {
		if(me.active != "") {
			me.pages[me.active].update();
		}
	},
	init: func() {
		me.timer.start();
	},
	showDlg: func {
		if(getprop("sim/instrument-options/canvas-popup-enable")) {
		    var dlg = canvas.Window.new([320, 400], "dialog");
		    dlg.setCanvas(me.display);
		}
	}
};
