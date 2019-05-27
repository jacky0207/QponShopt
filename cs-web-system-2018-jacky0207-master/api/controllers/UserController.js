/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    loginJson: function (req, res)
    {
        if (req.method == "GET")
        {
            return res.view('user/login');
        }
        else
        {
            User.findOne({ username: req.body.username }).exec(function (err, user) {

                if (user == null)
                    return res.send("No such user");

                if (user.role == "admin")
                    return res.send("No such user");

                // Load the bcrypt module
                var bcrypt = require('bcrypt');

                // Generate a salt
                var salt = bcrypt.genSaltSync(10);

                // if (user.password != req.body.password)
                if (!bcrypt.compareSync(req.body.password, user.password))
                    return res.send("Wrong Password");

                console.log("The session id " + req.session.id + " is going to be destroyed.");

                req.session.regenerate(function (err) {

                    console.log("The new session id is " + req.session.id + ".");

                    // req.session.username = req.body.username;
                    // req.session.userId = user.id;
                    // req.session.userRole = user.role;

                    var userData = {
                        id : user.id,
                        name : req.body.username,
                        image : user.image
                    };

                    // return res.json(req.session);
                    return res.json({ user : userData, message: "login successfully." });

                });
            });
        }
    },

    login: function (req, res)
    {
        if (req.method == "GET")
        {
            return res.view('user/login');
        }
        else
        {
            User.findOne({ username: req.body.username }).exec(function (err, user) {

                if (user == null)
                    return res.send("No such user");

                // Load the bcrypt module
                var bcrypt = require('bcrypt');

                // Generate a salt
                var salt = bcrypt.genSaltSync(10);

                // if (user.password != req.body.password)
                if (!bcrypt.compareSync(req.body.password, user.password))
                    return res.send("Wrong Password");

                console.log("The session id " + req.session.id + " is going to be destroyed.");

                req.session.regenerate(function (err) {

                    console.log("The new session id is " + req.session.id + ".");

                    req.session.username = req.body.username;
                    req.session.userId = user.id;
                    req.session.userRole = user.role;

                    // return res.json(req.session);
                    return res.send("login successfully.");

                });
            });
        }
    },

    logout: function (req, res) {
        if (req.session.username == undefined)
        {
            return res.redirect("/");
        }
        else
        {
            console.log("The current session id " + req.session.id + " is going to be destroyed.");

            req.session.destroy(function (err) {
                return res.redirect("/");
            });
        }
    },

    addSuperviseeJson: function (req, res) {

        if (req.method == "GET") {
            res.redirect('/');
        }
        else {
            // User.findOne(req.params.id).exec( function (err, model) {
            User.findOne(req.body.userId).exec( function (err, model) {
                
                var obj = {};

                Visitor.findOne(req.body.id).exec( function (err, visitor) {
                    if (model.coin < visitor.coin)
                    {
                        obj.message = "Not enough coin";
                        return res.json(obj);
                    }
                    if (visitor.quota <= 0)
                    {
                        obj.message = "Quota is full";
                        return res.json(obj);
                    }

                    if (model !== null) {
                        // coupon update
                        visitor.quota -= 1;
                        visitor.save();
                        
                        // user update
                        model.coin -= visitor.coin;
                        model.supervises.add(req.body.id);
                        model.save();
    
                        // return res.send("Supervisee added.");
                        obj.message = "Supervisee added."
                    }
                    else {
                        // return res.send("User not found!");
                        obj.message = "User not found!"
                    }
    
                    return res.json(obj);
                });
            });
        }
    },

    addSupervisee: function (req, res) {

        if (req.method == "GET") {
            res.redirect('/');
        }
        else {
            // User.findOne(req.params.id).exec( function (err, model) {
            User.findOne(req.session.userId).exec( function (err, model) {
                
                var obj = {};

                Visitor.findOne(req.query.pid).exec( function (err, visitor) {
                    if (model.coin < visitor.coin)
                    {
                        obj.message = "Not enough coin";
                        return res.json(obj);
                    }
                    if (visitor.quota <= 0)
                    {
                        obj.message = "Quota is full";
                        return res.json(obj);
                    }

                    if (model !== null) {
                        // coupon update
                        visitor.quota -= 1;
                        visitor.save();
                        
                        // user update
                        model.coin -= visitor.coin;
                        model.supervises.add(req.query.pid);
                        model.save();
    
                        // return res.send("Supervisee added.");
                        obj.message = "Supervisee added."
                    }
                    else {
                        // return res.send("User not found!");
                        obj.message = "User not found!"
                    }
    
                    return res.json(obj);
                });
            });
        }
    },

    couponmember: function (req, res) {
        Visitor.findOne(req.params.id).populateAll().exec( function (err, model) {        
            return res.view('user/couponmember', { 'coupon': model });                    
        });
    },

    // for test only
    removeSupervisee: function (req, res) {

        // if (req.method == "GET") {
        //     res.redirect('/');
        // }
        // else {
            // User.findOne(req.params.id).exec( function (err, model) {
            User.findOne(req.session.userId).exec( function (err, model) {

                var obj = {};

                if (model !== null) {
                    model.supervises.remove(req.query.pid)
                    model.save();
                    // return res.send("Supervisee removed!");
                    obj.message = "Supervisee removed!"
                }
                else {
                    // return res.send("User not found!");
                    obj.message = "User not found!"
                }

                return res.json(obj);
            });
        // }

    },

    mycouponJson: function (req, res) {

        User.findOne(req.body.id).populateAll().exec( function (err, user) {
            return res.json({ 'qpons': user.supervises });        
        });
    },

    mycoupon: function (req, res) {

        User.findOne(req.session.userId).populateAll().exec( function (err, user) {
            return res.view('user/mycoupon', { 'user': user });        
        });
    },

    // create function
    create: function (req, res)
    {
        if (req.method == "GET")
        {
            return res.view('user/create');
        }
        else
        {
            // Validation
            var visitor = JSON.parse(req.body.Visitor);

            if (!Validation.validDistrictAndMall(visitor))
            {
                return res.send("Invalid district and mall");
            }

            if (!Validation.validImage(visitor))
            {
                return res.send("Invalid image");
            }

            if (!Validation.validCoin(visitor))
            {
                return res.send("Invalid coin");
            }

            if (!Validation.validQuota(visitor))
            {
                return res.send("Invalid quota");
            }

            if (!Validation.validTill(visitor))
            {
                return res.send("Invalid till");
            }

            Visitor.create(visitor).exec(function (err, model) {
                return res.send("Visitor Created");
            });
        }
    },

    // admin function
    admin: function (req, res)
    {
        Visitor.find().exec(function (err, visitors) {
            return res.view('user/admin', { 'visitors': visitors });
        });
    },

    // update function
    update: function (req, res) {
        if (req.method == "GET")
        {
            Visitor.findOne(req.params.id).exec(function (err, model) {
                if (model == null)
                    return res.view('user/message', { 'message': "No such visitor." });
                else
                    return res.view('user/update', { 'visitor': model });
            });
        }
        else
        {
            Visitor.findOne(req.params.id).exec(function (err, model) {
                // Validation
                var visitor = JSON.parse(req.body.Visitor);

                if (!Validation.validDistrictAndMall(visitor))
                {
                    return res.send("Invalid district and mall");
                }

                if (!Validation.validImage(visitor))
                {
                    return res.send("Invalid image");
                }

                if (!Validation.validCoin(visitor))
                {
                    return res.send("Invalid coin");
                }

                if (!Validation.validQuota(visitor))
                {
                    return res.send("Invalid quota");
                }

                if (!Validation.validTill(visitor))
                {
                    return res.send("Invalid till");
                }
                
                model.title = visitor.title;
                model.restaurant = visitor.restaurant;
                model.district = visitor.district;
                model.mall = visitor.mall;
                model.image = visitor.image;
                model.coin = visitor.coin;
                model.till = visitor.till;
                model.quota = visitor.quota;
                model.details = visitor.details;
                model.save();
                // return res.view('visitor/message', { 'message': "Update successfully at " + new Date() + ".", 'menu': "admin" });
                // return res.redirect("user/admin");
                return res.send("Visitor Updated")
            });
        }
    },

    // delete function
    delete: function (req, res) {
        if (req.method == "GET")
        {
            res.redirect('/');
        }
        else
        {
            Visitor.findOne(req.params.id).exec(function (err, model) {
                var obj = {};

                if (model != null) {
                    model.destroy();
                    obj.message = "Visitor Deleted"
                } else {
                    obj.message = "Visitor not found";
                }

                return res.json(obj);
            });
        }
    },

};

