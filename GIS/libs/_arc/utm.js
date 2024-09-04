$UTM = function () {
    this.pi = 3.14159265358979;
    this.sm_a = 6378137.0;
    this.sm_b = 6356752.314;
    this.sm_EccSquared = 6.69437999013e-03;
    this.UTMScaleFactor = 0.9996;
};
$UTM.prototype = {
    DegToRad: function (deg) {
        return (deg / 180.0 * this.pi);
    },
    RadToDeg: function (rad) {
        return (rad / this.pi * 180.0)
    },
    ArcLengthOfMeridian: function (phi) {
        var alpha, beta, gamma, delta, epsilon, n;
        n = (this.sm_a - this.sm_b) / (this.sm_a + this.sm_b);
        alpha = ((this.sm_a + this.sm_b) / 2.0) * (1.0 + (Math.pow(n, 2.0) / 4.0) + (Math.pow(n, 4.0) / 64.0));
        beta = (-3.0 * n / 2.0) + (9.0 * Math.pow(n, 3.0) / 16.0) + (-3.0 * Math.pow(n, 5.0) / 32.0);
        gamma = (15.0 * Math.pow(n, 2.0) / 16.0) + (-15.0 * Math.pow(n, 4.0) / 32.0);
        delta = (-35.0 * Math.pow(n, 3.0) / 48.0) + (105.0 * Math.pow(n, 5.0) / 256.0);
        epsilon = (315.0 * Math.pow(n, 4.0) / 512.0);
        return alpha * (phi + (beta * Math.sin(2.0 * phi)) + (gamma * Math.sin(4.0 * phi)) + (delta * Math.sin(6.0 * phi)) + (epsilon * Math.sin(8.0 * phi)));
    },
    UTMCentralMeridian: function (zone) {
        var cmeridian;
        cmeridian = this.DegToRad(-183.0 + (zone * 6.0));
        return cmeridian;
    },
    FootpointLatitude: function (y) {
        var y_, alpha_, beta_, gamma_, delta_, epsilon_, n;
        var result;
        n = (this.sm_a - this.sm_b) / (this.sm_a + this.sm_b);
        alpha_ = ((this.sm_a + this.sm_b) / 2.0) * (1 + (Math.pow(n, 2.0) / 4) + (Math.pow(n, 4.0) / 64));
        y_ = y / alpha_;
        beta_ = (3.0 * n / 2.0) + (-27.0 * Math.pow(n, 3.0) / 32.0) + (269.0 * Math.pow(n, 5.0) / 512.0);
        gamma_ = (21.0 * Math.pow(n, 2.0) / 16.0) + (-55.0 * Math.pow(n, 4.0) / 32.0);
        delta_ = (151.0 * Math.pow(n, 3.0) / 96.0) + (-417.0 * Math.pow(n, 5.0) / 128.0);
        epsilon_ = (1097.0 * Math.pow(n, 4.0) / 512.0);
        return y_ + (beta_ * Math.sin(2.0 * y_)) + (gamma_ * Math.sin(4.0 * y_)) + (delta_ * Math.sin(6.0 * y_)) + (epsilon_ * Math.sin(8.0 * y_));
    },
    MapLatLonToXY: function (phi, lambda, lambda0, xy) {
        var N, nu2, ep2, t, t2, l;
        var l3coef, l4coef, l5coef, l6coef, l7coef, l8coef;
        var tmp;
        ep2 = (Math.pow(this.sm_a, 2.0) - Math.pow(this.sm_b, 2.0)) / Math.pow(this.sm_b, 2.0);
        nu2 = ep2 * Math.pow(Math.cos(phi), 2.0);
        N = Math.pow(this.sm_a, 2.0) / (this.sm_b * Math.sqrt(1 + nu2));
        t = Math.tan(phi);
        t2 = t * t;
        tmp = (t2 * t2 * t2) - Math.pow(t, 6.0);
        l = lambda - lambda0;
        l3coef = 1.0 - t2 + nu2;
        l4coef = 5.0 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2);
        l5coef = 5.0 - 18.0 * t2 + (t2 * t2) + 14.0 * nu2 - 58.0 * t2 * nu2;
        l6coef = 61.0 - 58.0 * t2 + (t2 * t2) + 270.0 * nu2 - 330.0 * t2 * nu2;
        l7coef = 61.0 - 479.0 * t2 + 179.0 * (t2 * t2) - (t2 * t2 * t2);
        l8coef = 1385.0 - 3111.0 * t2 + 543.0 * (t2 * t2) - (t2 * t2 * t2);
        xy[0] = N * Math.cos(phi) * l + (N / 6.0 * Math.pow(Math.cos(phi), 3.0) * l3coef * Math.pow(l, 3.0)) + (N / 120.0 * Math.pow(Math.cos(phi), 5.0) * l5coef * Math.pow(l, 5.0)) + (N / 5040.0 * Math.pow(Math.cos(phi), 7.0) * l7coef * Math.pow(l, 7.0));
        xy[1] = this.ArcLengthOfMeridian(phi) + (t / 2.0 * N * Math.pow(Math.cos(phi), 2.0) * Math.pow(l, 2.0)) + (t / 24.0 * N * Math.pow(Math.cos(phi), 4.0) * l4coef * Math.pow(l, 4.0)) + (t / 720.0 * N * Math.pow(Math.cos(phi), 6.0) * l6coef * Math.pow(l, 6.0)) + (t / 40320.0 * N * Math.pow(Math.cos(phi), 8.0) * l8coef * Math.pow(l, 8.0));
    },
    MapXYToLatLon: function (x, y, lambda0, philambda) {
        var phif, Nf, Nfpow, nuf2, ep2, tf, tf2, tf4, cf;
        var x1frac, x2frac, x3frac, x4frac, x5frac, x6frac, x7frac, x8frac;
        var x2poly, x3poly, x4poly, x5poly, x6poly, x7poly, x8poly;
        phif = this.FootpointLatitude(y);
        ep2 = (Math.pow(this.sm_a, 2.0) - Math.pow(this.sm_b, 2.0)) / Math.pow(this.sm_b, 2.0);
        cf = Math.cos(phif);
        nuf2 = ep2 * Math.pow(cf, 2.0);
        Nf = Math.pow(this.sm_a, 2.0) / (this.sm_b * Math.sqrt(1 + nuf2));
        Nfpow = Nf;
        tf = Math.tan(phif);
        tf2 = tf * tf;
        tf4 = tf2 * tf2;
        x1frac = 1.0 / (Nfpow * cf);
        Nfpow *= Nf;
        x2frac = tf / (2.0 * Nfpow);
        Nfpow *= Nf;
        x3frac = 1.0 / (6.0 * Nfpow * cf);

        Nfpow *= Nf;
        x4frac = tf / (24.0 * Nfpow);

        Nfpow *= Nf;
        x5frac = 1.0 / (120.0 * Nfpow * cf);

        Nfpow *= Nf;
        x6frac = tf / (720.0 * Nfpow);

        Nfpow *= Nf;
        x7frac = 1.0 / (5040.0 * Nfpow * cf);

        Nfpow *= Nf;
        x8frac = tf / (40320.0 * Nfpow);

        x2poly = -1.0 - nuf2;
        x3poly = -1.0 - 2 * tf2 - nuf2;
        x4poly = 5.0 + 3.0 * tf2 + 6.0 * nuf2 - 6.0 * tf2 * nuf2 - 3.0 * (nuf2 * nuf2) - 9.0 * tf2 * (nuf2 * nuf2);
        x5poly = 5.0 + 28.0 * tf2 + 24.0 * tf4 + 6.0 * nuf2 + 8.0 * tf2 * nuf2;
        x6poly = -61.0 - 90.0 * tf2 - 45.0 * tf4 - 107.0 * nuf2 + 162.0 * tf2 * nuf2;
        x7poly = -61.0 - 662.0 * tf2 - 1320.0 * tf4 - 720.0 * (tf4 * tf2);
        x8poly = 1385.0 + 3633.0 * tf2 + 4095.0 * tf4 + 1575 * (tf4 * tf2);

        philambda[0] = phif + x2frac * x2poly * (x * x) + x4frac * x4poly * Math.pow(x, 4.0) + x6frac * x6poly * Math.pow(x, 6.0) + x8frac * x8poly * Math.pow(x, 8.0);
        philambda[1] = lambda0 + x1frac * x + x3frac * x3poly * Math.pow(x, 3.0) + x5frac * x5poly * Math.pow(x, 5.0) + x7frac * x7poly * Math.pow(x, 7.0);
    },
    LatLonToUTMXY: function (lat, lon, zone, xy) {
        this.MapLatLonToXY(this.DegToRad(lat), this.DegToRad(lon), this.UTMCentralMeridian(zone), xy);
        xy[0] = xy[0] * this.UTMScaleFactor + 500000.0;
        xy[1] = xy[1] * this.UTMScaleFactor;
        if (xy[1] < 0.0) {
            xy[1] = xy[1] + 10000000.0;
        }
        return zone;
    },
    UTMXYToLatLon: function (x, y, zone, southhemi, latlon) {
        var cmeridian;
        x -= 500000.0;
        x /= this.UTMScaleFactor;
        if (southhemi) {
            y -= 10000000.0;
        }
        y /= this.UTMScaleFactor;
        cmeridian = this.UTMCentralMeridian(zone);
        this.MapXYToLatLon(x, y, cmeridian, latlon);
        return;
    }
};