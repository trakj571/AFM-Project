L.BingLayer = L.TileLayer.extend({
	options: {
		subdomains: [0, 1, 2, 3],
		type: 'Aerial',
		attribution: 'Bing',
		culture: ''
	},

	initialize: function(url, options) {
		L.Util.setOptions(this, options);

		this._key = "";
		this._url = url;
	},

	tile2quad: function(x, y, z) {
		var quad = '';
		for (var i = z; i > 0; i--) {
			var digit = 0;
			var mask = 1 << (i - 1);
			if ((x & mask) != 0) digit += 1;
			if ((y & mask) != 0) digit += 2;
			quad = quad + digit;
		}
		return quad;
	},

	getTileUrl: function(p, z) {
		var z = this._getZoomForUrl();
		var subdomains = this.options.subdomains,
			s = this.options.subdomains[Math.abs((p.x + p.y) % subdomains.length)];
		return this._url.replace('{subdomain}', s)
				.replace('{quadkey}', this.tile2quad(p.x, p.y, z))
				//.replace('http:', document.location.protocol)
				.replace('{culture}', this.options.culture);
	},

	loadMetadata: function() {
		var _this = this;
		var cbid = '_bing_metadata_' + L.Util.stamp(this);
		window[cbid] = function (meta) {
			_this.meta = meta;
			window[cbid] = undefined;
			var e = document.getElementById(cbid);
			e.parentNode.removeChild(e);
			if (meta.errorDetails) {
				alert("Got metadata" + meta.errorDetails);
				return;
			}
			_this.initMetadata();
		};
	},

	initMetadata: function() {
		this._update();
	},

	_update: function() {
		if (this._url == null || !this._map) return;
		this._update_attribution();
		L.TileLayer.prototype._update.apply(this, []);
	},

	_update_attribution: function() {
		
	},

	onRemove: function(map) {
	    L.TileLayer.prototype.onRemove.apply(this, [map]);
	}
});

L.bingLayer = function (url, options) {
    return new L.BingLayer(url, options);
};





L.YahooLayer = L.TileLayer.extend({
    options: {
        subdomains: [0, 1, 2, 3],
        type: 'Aerial',
        attribution: 'Yahoo',
        culture: ''
    },

    initialize: function (url, options) {
        L.Util.setOptions(this, options);

        this._url = url;
    },

    tile2quad: function (x, y, z) {
        var quad = '';
        for (var i = z; i > 0; i--) {
            var digit = 0;
            var mask = 1 << (i - 1);
            if ((x & mask) != 0) digit += 1;
            if ((y & mask) != 0) digit += 2;
            quad = quad + digit;
        }
        return quad;
    },

    getTileUrl: function (p) {
        var z = 18 - p.z;
        var num4 = Math.pow(2.0, p.z) / 2.0;
        var y;
        if (p.y < num4) {
            y = (num4 - p.y) - 1;
        }
        else {
            y = ((p.y + 1) - num4) * -1;
        }
        return this._url.replace('{x}', p.x)
				.replace('{y}', y)
				.replace('{z}', z);
    },


    _update: function () {
        if (this._url == null || !this._map) return;
        L.TileLayer.prototype._update.apply(this, []);
    },

    onRemove: function (map) {
        L.TileLayer.prototype.onRemove.apply(this, [map]);
    }
});

L.yahooLayer = function (url, options) {
    return new L.YahooLayer(url, options);
};
