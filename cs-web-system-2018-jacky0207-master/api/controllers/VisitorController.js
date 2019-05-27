/**
 * VisitorController
 *
 * @description :: Server-side logic for managing Visitors
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
	// json function
    json: function (req, res) {
        Visitor.find()
        .where({ till: { '>=' : new Date() } })
        .exec(function (err, visitors) {
            return res.json(visitors);
        });
    },

    validQPonJson: function(req, res) {
        Visitor.find()
        .where({ till: { '>=' : new Date() } })
        .sort('till').exec(function (err, qpons) {
            return res.json(qpons);
        });
    },

    // index function
    index: function (req, res) {
        // Visitor.count().exec(function (err, count)
        // {      
            // if (count == 0)
            // {
            //     return;
            // }

            Visitor.find()
            .where({ till: { '>=' : new Date() } })
            .sort('till').exec(function (err, visitors) {
                return res.view('visitor/index', { 'visitors': visitors });
            });
        // });
    },

    detailJson: function (req, res) {
        Visitor.findOne(req.body.id)
        .exec(function (err, model) {
            if (model != null)
            {
                if (req.body.userId == "")
                {
                    return res.json({ 'qpon': model, 'redeemed': false });
                }
                else
                {
                    var redeemed = false;

                    User.findOne(req.body.userId).populateAll().exec( function (err, user) {
                        user.supervises.forEach( function(model) {
                            if (model.id == req.body.id)
                            {
                                redeemed = true;
                            }
                        });
                        return res.json({ 'qpon': model, 'redeemed': redeemed });
                    });
                }
            }
            else
                return res.send("No such visitor");
        });
    },

    // view function
    detail: function (req, res) {
        Visitor.findOne(req.params.id).exec(function (err, model) {
            if (model != null)
            {
                if (req.session.userId == undefined)
                {
                    return res.view('visitor/detail', { 'visitor': model, 'redeemed': false });
                }
                else
                {
                    var redeemed = false;

                    User.findOne(req.session.userId).populateAll().exec( function (err, user) {
                        user.supervises.forEach( function(model) {
                            if (model.id == req.params.id)
                            {
                                redeemed = true;
                            }
                        });
                        return res.view('visitor/detail', { 'visitor': model, 'redeemed': redeemed });
                    });
                }
            }
            else
                return res.send("No such visitor");
        });
    },

    searchJson: function (req, res) {
        var qmall = req.body.mall;
        var qcoin = req.body.coin;
        var qdirection = req.body.direction;

        var visitorSearch = Visitor.find().where({ till: { '>=' : new Date() } });

        if (qmall != "")
        {
            visitorSearch = visitorSearch.where({ mall: { contains: qmall } });
        }
        else if (qcoin != "")
        {
            if (qdirection == '<')
            {
                visitorSearch = visitorSearch.where({ coin: { '<' : qcoin }});
            }
            else if (qdirection == '>=')
            {
                visitorSearch = visitorSearch.where({ coin: { '>=' : qcoin }});
            }
        }

       
        visitorSearch.exec(function (err, qpons) {
            return res.json(qpons);
        });
    },
    
    // search function
    search: function (req, res) {
        const qPage = req.query.page || 1;

        var qdistrict = "";
        var qcoin = "0;10000";
        var qtill = "";

        if (typeof(req.body) != 'undefined')
        {
            qdistrict = req.body.Visitor.district || "";
            qcoin = req.body.Visitor.coin || "0;10000";
            qtill = req.body.Visitor.till || "";
        }
        else
        {
            if (typeof(req.query.district) != 'undefined')
            {
                qdistrict = req.query.district;
            }
            if (typeof(req.query.coin) != 'undefined')
            {
                qcoin = req.query.coin;
            }
            if (typeof(req.query.till) != 'undefined')
            {
                qtill = req.query.till;
            }
        }

        const data = {
            district : qdistrict,
            coin : qcoin,
            till : qtill
        }

        var coinDigit = qcoin.split(";");
        var startCoin = coinDigit[0];
        var endCoin = coinDigit[1];

        var visitorSearch = Visitor.find()
        .where({ district: { contains: qdistrict } })
        .where({ coin: { '>=' : startCoin, "<=" : endCoin }})
        .where({ till: { '>=' : new Date(), '<=' : new Date((qtill == "") ? "12/30/9999" : qtill) } })
        .paginate({ page: qPage, limit: 2 })
        .exec(function (err, visitors) {
            Visitor.count()
            .where({ district: { contains: qdistrict } })
            .where({ coin: { '>=' : startCoin, "<=" : endCoin }})
            .where({ till: { '>=' : new Date(), '<=' : new Date((qtill == "") ? "12/30/9999" : qtill) } })
            .exec(function (err, value) {
                var pages = Math.ceil(value / 2);
                return res.view('visitor/search', { 'visitors': visitors, 'count': pages, 'data': data });
            });
        });
    },

};

