# A380 Flightplan management system
# Copyright Narendran Muraleedharan 2014 - shared under CC-BY-NC v3.0

# Depends: FG positioned API

var flightplan = {
	active: 0,
	currentWptId: 0,
	wpts: [], # Array of wpt objects
	flt_nbr: "",
	depICAO: "",
	arrICAO: "",
	alternate: "",
	crz_FL: 0,
	cpny_rte: "",
	set_cpny_rte: func() {
		#FIXME
	},
	altn_rte: "",
	set_altn_rte: func() {
		#FIXME
	},
	fly_altn_rte: func() {
		#FIXME
	},
	dirTo: func(id) {
		me.currentWptId = id;
	},
	setAltitude: func(id, alt) {
		me.wpts[id].setAltitude(alt);
	},
	setSpeed: func(id, spd) {
		me.wpts[id].setSpeed(spd);
	},
	nextWpt: func() {
		if(me.currentWptId < size(me.wpts)-1) {
			me.currentWptId = me.currentWptId + 1;
		} else {
			print("[FMGC] END OF F-PLN");
		}
	},
	appendWpt: func(wpt) {
		setsize(me.wpts, size(me.wpts) + 1);
		me.wpts[size(me.wpts) - 1] = wpt;
	},
	insertWpt: func(id, wpt) {
		var _wpts = [];
		setsize(_wpts, size(me.wpts) + 1);
		forindex(var i; me.wpts) {
			if(i < id) {
				_wpts[i] = me.wpts[i];
			} else {
				_wpts[i+1] = me.wpts[i];
			}
		}
		_wpts[id] = wpt;
		me.wpts = _wpts;
	},
	deleteWpt: func(id) {
		var _wpts = [];
		setsize(_wpts, size(me.wpts)-1);
		forindex(var i; _wpts) {
			if(i < id) {
				_wpts[i] = me.wpts[i];
			} else {
				_wpts[i] = me.wpts[i+1];
			}
		}
		me.wpts = _wpts;
	},
	getHdgToFollow: func() {
		if(me.currentWptId < size(me.wpts)) {
			return me.wpts[me.currentWptId].getDctHeading;
		} else {
			return me.wpts[size(me.wpts) - 1].getDctHeading; # Else return last waypoint
		}
	},
	getTargetSpeed: func() {
		if(me.currentWptId < size(me.wpts)) {
			return me.wpts[me.currentWptId].speed;
		} else {
			return me.wpts[size(me.wpts) - 1].speed; # Else return last waypoint
		}
	},
	getTargetVS: func() {
		if(me.currentWptId < size(me.wpts)) {
			return me.wpts[me.currentWptId].getTargetVS;
		} else {
			return me.wpts[size(me.wpts) - 1].getTargetVS; # Else return last waypoint
		}
	},
	getRouteDistance: func() {
		var distance = 0;
		forindex(var i; me.wpts) {
			if(i == 0) {
				distance += me.wpts[i].getDctDistance;
			} else {
				distance += me.wpts[i].getDistFrom(me.wpts[i-1]);
			}
		}
		return distance;
	},
	getRemainingDist: func() {
		var distance = 0;
		for(var i=me.currentWptId; i<size(me.wpts); i=i+1) {
			if(i == 0) {
				distance += me.wpts[i].getDctDistance;
			} else {
				distance += me.wpts[i].getDistFrom(me.wpts[i-1]);
			}
		}
		return distance;
	},
	getDistToNextWpt: func() {
		if(me.currentWptId < size(me.wpts)) {
			return me.wpts[me.currentWptId].getDctDistance;
		} else {
			return me.wpts[size(me.wpts) - 1].getDctDistance; # Else return last waypoint
		}
	},
	new: func() {
		return t = {parents:[flightplan]};
	}
};
