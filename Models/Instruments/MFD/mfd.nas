# (Airbus A380) Multi-Function Display for Flight Programming/Management
# Narendran Muraleedharan (c) 2014

# Object Types --> click, textbox, label

var font_mapper = func(family, weight)
{
	if( family == "Liberation Sans" and weight == "normal" )
		return "LiberationFonts/LiberationSans-Regular.ttf";
};

var colors = {
	gray1: [0.314, 0.314, 0.314],
	gray2: [0.627, 0.627, 0.627],
	blue1: [0.000, 0.706, 1.000]
};

var mfd = {
	new: func(placement, svg_path) {
		var t = {parents:[mfd]};
		t.display = canvas.new({
			"name":			"MFD Display",
			"size":			[800, 1024],
			"view":			[800, 1024],
			"mipmapping":	1
		});
		
		t.svgCache = {};
		
		t.display.addPlacement({"node": placement, "capture-events": 1});
		t.svgGroup = t.display.createGroup();	# SVG Objects for pages
		canvas.parsesvg(t.svgGroup, svg_path, {'font-mapper':font_mapper});		
		
		foreach(var element; ["dropdown", "fms1_click", "fms2_click", "atc_com_click", "surv_click", "fcu_bkup_click", "fms1_text", "fms2_text", "atc_com_text", "surv_text", "fcu_bkup_text", "fms_mode_text", "fms_mode_box", "fms_mode_static", "active_box", 
"position_box", "active_dropdown", "position_dropdown", "active_current", "position_current", "active_fpln_box", "active_perf_box", "active_fuel_box", "active_wind_box", "active_init_box", "position_navaids_box", "position_navaids_text", "page_title", "connect_current", "request_current", "report_current", "msg_record_current", "status_current", "controls_current", "autoflight_current", "efis_current", "active_fpln_text", "active_perf_text", "active_fuel_text", "active_wind_text", "active_init_text"]) {
			t.svgCache[element] = t.svgGroup.getElementById(element);
		}
		
		t.activePage = "";
		t.activeMenu = "";
		t.menus = {
			'menu_surv': {
				widgets: [
					#FIXME
				],
				load: func() {
					
				}
			},
			'menu_fms': {
				widgets: [
					#FIXME
				],
				load: func() {
					
				},
				pages: {
					'fms_active_init': {
						widgets: [
							#FIXME
						],
						load: func() {
							
						}
					},
					'fms_active_fpln': {
						widgets: [
							#FIXME
						],
						load: func() {
							
						}
					},
					'fms_active_fuel': {
						widgets: [
							#FIXME
						],
						load: func() {
							
						}
					},
					'fms_active_perf': {
						widgets: [
							#FIXME
						],
						load: func() {
							
						}
					}
				}
			},
			'menu_fcu_bkup': {
				widgets: [
					#FIXME
				],
				load: func() {
					
				}
			},
			'menu_atc_com': {
				widgets: [
					#FIXME
				],
				load: func() {
					
				}
			}
		};
		t.menuLayers = ['menu_surv', 'menu_fms', 'menu_fcu_bkup', 'menu_atc_com'];
		t.pageLayers = ['fms_active_init', 'fms_active_fpln', 'fms_active_fuel', 'fms_active_perf'];
		
		foreach(var layer; t.menuLayers) {
			t.svgCache[layer] = t.svgGroup.getElementById(layer);
		}
		foreach(var layer; t.pageLayers) {
			t.svgCache[layer] = t.svgGroup.getElementById(layer);
		}
		
		t.svgCache["position_dropdown"].hide();
		t.svgCache["active_dropdown"].hide();
		t.svgCache["position_dropdown"].hide();
		t.svgCache["dropdown"].hide();
		
		foreach(var widget; [
			{
				type: 'click',
				objects: ["fms_mode_text", "fms_mode_box", "fms_mode_static"],
				function: func() {
					t.svgCache["position_dropdown"].hide();
					t.svgCache["active_dropdown"].hide();
					if(t.svgCache["dropdown"].getVisible()) {
						t.svgCache["dropdown"].hide();
						t.svgCache["fms_mode_box"].setColorFill(colors.gray1);
					} else {
						t.svgCache["dropdown"].show();
						t.svgCache["fms_mode_box"].setColorFill(colors.gray2);
					}
				}
			},
			{
				type: 'click',
				objects: ["fms1_click", "fms1_text"],
				function: func() {
					t.svgCache["fms1_click"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["dropdown"].hide();
						t.svgCache["fms1_click"].setColor(colors.gray1);
						t.svgCache["fms_mode_box"].setColorFill(colors.gray1);
						t.svgCache["fms_mode_text"].setText("FMS1");
						t.loadPage("menu_fms", "fms_active_init");
						t.svgCache["position_current"].hide();
						t.svgCache["active_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["atc_com_click", "atc_com_text"],
				function: func() {
					t.svgCache["atc_com_click"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["dropdown"].hide();
						t.svgCache["atc_com_click"].setColor(colors.gray1);
						t.svgCache["fms_mode_box"].setColorFill(colors.gray1);
						t.svgCache["fms_mode_text"].setText("ATC COM");
						t.loadPage("menu_atc_com", "atc_com_connect");
						t.svgCache["report_current"].hide();
						t.svgCache["request_current"].hide();
						t.svgCache["msg_record_current"].hide();
						t.svgCache["connect_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["surv_click", "surv_text"],
				function: func() {
					t.svgCache["surv_click"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["dropdown"].hide();
						t.svgCache["surv_click"].setColor(colors.gray1);
						t.svgCache["fms_mode_box"].setColorFill(colors.gray1);
						t.svgCache["fms_mode_text"].setText("SURV");
						t.loadPage("menu_surv", "surv_controls");
						t.svgCache["status_current"].hide();
						t.svgCache["controls_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["fcu_bkup_click", "fcu_bkup_text"],
				function: func() {
					t.svgCache["fcu_bkup_click"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["dropdown"].hide();
						t.svgCache["fcu_bkup_click"].setColor(colors.gray1);
						t.svgCache["fms_mode_box"].setColorFill(colors.gray1);
						t.svgCache["fms_mode_text"].setText("FCU BKUP");
						t.loadPage("menu_fcu_bkup", "fcu_bkup_autoflight");
						t.svgCache["efis_current"].hide();
						t.svgCache["autoflight_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["active_box", "active_current"],
				function: func() {
					t.svgCache["dropdown"].hide();
					t.svgCache["position_dropdown"].hide();
					if(t.svgCache["active_dropdown"].getVisible()) {
						t.svgCache["active_dropdown"].hide();
						t.svgCache["active_box"].setColorFill(colors.gray1);
					} else {
						t.svgCache["active_dropdown"].show();
						t.svgCache["active_box"].setColorFill(colors.gray2);
					}
				}
			},
			{
				type: 'click',
				objects: ["position_box", "position_current"],
				function: func() {
					t.svgCache["dropdown"].hide();
					t.svgCache["active_dropdown"].hide();
					if(t.svgCache["position_dropdown"].getVisible()) {
						t.svgCache["position_dropdown"].hide();
						t.svgCache["position_box"].setColorFill(colors.gray1);
					} else {
						t.svgCache["position_dropdown"].show();
						t.svgCache["position_box"].setColorFill(colors.gray2);
					}
				}
			},
			{
				type: 'click',
				objects: ["active_fpln_box", "active_fpln_text"],
				function: func() {
					t.svgCache["active_fpln_box"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["active_dropdown"].hide();
						t.svgCache["active_box"].setColorFill(colors.gray1);
						t.svgCache["active_fpln_box"].setColor(colors.gray1);
						t.svgCache["page_title"].setText("ACTIVE / F-PLN");
						t.loadPage("menu_fms", "fms_active_fpln");
						t.svgCache["position_current"].hide();
						t.svgCache["active_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["active_perf_box", "active_perf_text"],
				function: func() {
					t.svgCache["active_perf_box"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["active_dropdown"].hide();
						t.svgCache["active_box"].setColorFill(colors.gray1);
						t.svgCache["active_perf_box"].setColor(colors.gray1);
						t.svgCache["page_title"].setText("ACTIVE / PERF");
						t.loadPage("menu_fms", "fms_active_perf");
						t.svgCache["position_current"].hide();
						t.svgCache["active_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["active_fuel_box", "active_fuel_text"],
				function: func() {
					t.svgCache["active_fuel_box"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["active_dropdown"].hide();
						t.svgCache["active_box"].setColorFill(colors.gray1);
						t.svgCache["active_fuel_box"].setColor(colors.gray1);
						t.svgCache["page_title"].setText("ACTIVE / FUEL & LOAD");
						t.loadPage("menu_fms", "fms_active_fuel");
						t.svgCache["position_current"].hide();
						t.svgCache["active_current"].show();
					}, 0.1);
				}
			},
			{
				type: 'click',
				objects: ["active_init_box", "active_init_text"],
				function: func() {
					t.svgCache["active_init_box"].setColor(colors.blue1);
					settimer(func {
						t.svgCache["active_dropdown"].hide();
						t.svgCache["active_box"].setColorFill(colors.gray1);
						t.svgCache["active_init_box"].setColor(colors.gray1);
						t.svgCache["page_title"].setText("ACTIVE / INIT");
						t.loadPage("menu_fms", "fms_active_init");
						t.svgCache["position_current"].hide();
						t.svgCache["active_current"].show();
					}, 0.1);
				}
			}
		]) {
			if(widget.type == 'click') {
				foreach(var obj; widget.objects) {
					t.svgCache[obj].addEventListener("click", widget.function);
				}
			}
		}
		
		return t;
	},
	loadPage: func(menu, page) {
		if(page != me.activePage) {
			# Clear all other page layers and show active page layer
			foreach(var layer; me.pageLayers) {
				me.svgCache[layer].hide();
			}
			me.svgCache[page].show();
			# Run page load function
			me.menus[menu].pages[page].load();
			if(menu != me.activeMenu) {
				foreach(var layer; me.menuLayers) {
					me.svgCache[layer].hide();
				}
				me.svgCache[menu].show();
				# Run page load function
				me.menus[menu].load();
			}
		}
	},
	showDlg: func {
		if(getprop("sim/instrument-options/canvas-popup-enable")) {
		    var dlg = canvas.Window.new([400, 512], "dialog");
		    dlg.setCanvas(me.display);
		}
	}
};
