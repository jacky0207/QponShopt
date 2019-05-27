# assignment1

This is a [Sails](http://sailsjs.org) application of a coupon

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
sails
```

### Installing

Make sure Node.js has been installed in your station, as Sails runs on top of Node.js.

Bring up the Terminal and install sails.js with these commands

```
sudo npm install -g sails
```

## Running the tests

First you need to start the server in terminal

```
sails lift --models.migrate='alter'
```

then visit http://localhost:1337/ to see the default page

### Generating a JSON output

One way to view the stored items in our database is to generate a JSON feed. Add the following in the VisitorController.js again.

```
// json function
    json: function (req, res) {
        Visitor.find().exec(function (err, visitors) {
            return res.json(visitors);
        });
    },
```

then restart the server and visit http://localhost:1337/visitor/json to view the json file

### View latest coupon

Add the following function to your VisitorController.js, inside the braces. The first two coupons are shown in each district.

```
// index function
    index: function (req, res) {
        Visitor.find()
        .where({ till: { '>=' : new Date() } })
        .sort('till').exec(function (err, visitors) {
            return res.view('visitor/index', { 'visitors': visitors });
        });
    },
```

Under the views folder, create a new folder named visitor. Create a new file named as index.ejs.

```
<!--index.ejs-->
<div class="row">
    <div class="col-12 col-md-4">
        <label>HK Island</label>
    <%
        var count = 0;
        visitors.forEach( function(model) {
            if (count == 2)
            {
                return;
            }

            if(model.district == "HK Island")
            {
                count++;
    %>
        <div class="container card">
            <img src="<%= model.image %>" alt="Image" width="100%">
            <a href="/visitor/detail/<%= model.id %>"><%= model.restaurant %></a>
            <label><%= model.title %></label>
            <label>Coins: <%= model.coin %></label>
        </div>
        
        <br>
    <%
            }
        });
    %>
    </div>

    <div class="col-12 col-md-4">
        <label>Kowloon</label>
    <%
        count = 0;
        visitors.forEach( function(model) {
            if (count == 2)
            {
                return;
            }

            if(model.district == "Kowloon")
            {
                count++;
    %>
        <div class="container card">
            <img src="<%= model.image %>" alt="Image" width="100%">
            <a href="/visitor/detail/<%= model.id %>"><%= model.restaurant %></a>
            <label><%= model.title %></label>
            <label>Coins: <%= model.coin %></label>
        </div>

        <br>
    <%    
            }
        });
    %>
    </div>

    <div class="col-12 col-md-4">
        <label>New Territories</label>
    <%
        count = 0;
        visitors.forEach( function(model) {
            if (count == 2)
            {
                return;
            }

            if(model.district == "New Territories")
            {
                count++;
    %>
        <div class="container card">
            <img src="<%= model.image %>" alt="Image" width="100%">
            <a href="/visitor/detail/<%= model.id %>"><%= model.restaurant %></a>
            <label><%= model.title %></label>
            <label>Coins: <%= model.coin %></label>
        </div>
        
        <br>
    <%    
            }
        });
    %>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#home").addClass('active');
    });
</script>
```

Now, you can restart the server and go to http://localhost:1337/visitor/create to view latest coupons.

### Create coupon

Add the following function to your VisitorController.js, inside the braces.

```
// create function
    create: function (req, res) {
        if (req.method == "POST") {
            Visitor.create(req.body.Visitor).exec(function (err, model) {
                return res.view('visitor/message', { 'message': "Create successfully at " + new Date() + ".", 'menu' : "create" });
            });
        } else {
            return res.view('visitor/create');
        }
    },
```

Under the visitor folder, create a new file named as create.ejs.

```
<!--create.ejs-->
<form action="/visitor/create" method="POST">
    <div class="row">
        <div class="col-12 col-md-6">
            <div class="form-group">
                <label>Title:</label>
                <input type="text" class="form-control" name="Visitor[title]" required>
            </div>
            <div class="form-group">
                <label>Restaurant:</label>
                <input type="text" class="form-control" name="Visitor[restaurant]" required>
            </div>
            <div class="form-group">
                <label>District:</label>
                <select class="form-control" name="Visitor[district]" id="district" onchange="districtSelected()">
                    <option value="">Please select one</option>
                    <option value="HK Island">HK Island</option>
                    <option value="Kowloon">Kowloon</option>
                    <option value="New Territories">New Territories</option>
                </select>
            </div>
            <div class="form-group">
                <label>Mall:</label>
                <select class="form-control" name="Visitor[mall]" id="mall" disabled>
                </select>
            </div>
            <div class="form-group">
                <label>Image:</label>
                <input type="text" class="form-control" name="Visitor[image]">
            </div>
        </div>

        <div class="col-12 col-md-6">
            <div class="form-group">
                <label>Coin:</label>
                <input type="text" class="form-control" name="Visitor[coin]">
            </div>
            <div class="form-group">
                <label>Deal Valid Till</label>
                <input type="text" class="form-control" name="Visitor[till]" data-provide="datepicker" id="till">
            </div>
            <div class="form-group">
                <label>Quota:</label>
                <input type="number" min="0" class="form-control" name="Visitor[quota]">
            </div>
            <div class="form-group">
                <label>Details:</label>
                <textarea class="form-control" rows="4" name="Visitor[details]"></textarea>
            </div>
        </div>
    </div>
    <input type="submit" class="btn btn-primary" value="Create">
</form>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#create").addClass('active');

        // Date picker
        $('#till').datepicker({
            minDate: new Date()
        });
    });

    // District selector
    var hkIsland = ["IFC", "金鐘太古廣場", "時代廣場", "銅鑼灣世貿中心", "太古城中心", "杏花新城商場", "數碼港商場"];
    var kowloon = ["圓方", "Elements", "Harbour", "City", "海港城", "美麗華商場", "黃埔新天地", "又一城", "朗豪坊商場", "新世紀廣場", "奧海城", "MegaBox", "德福廣場商場", "荷里活廣場", "APM"];
    var newTerritories = ["荃新天地", "荃灣廣場", "悅來坊商場", "綠楊坊商場", "新都會廣場", "青衣城商場", "屯門市廣場", "東港城", "君薈坊商場", "連理街", "沙田新城市廣場", "大埔超級城"];

    function districtSelected() {
        var district = document.getElementById("district").value;

        var mall = document.getElementById("mall");
        mall.options.length = 0;

        if (district == "HK Island")
        {
            for (item of hkIsland)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }

            mall.disabled = false;
        }
        else if (district == "Kowloon")
        {
            for (item of kowloon)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }
            mall.disabled = false;
        }
        else if (district == "New Territories")
        {
            for (item of newTerritories)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }
            mall.disabled = false;
        }
        else
        {
            mall.disabled = true;
        }
    }
</script>
```

Now, you can restart the server and go to http://localhost:1337/visitor/create to create coupon.

### Search coupon

Here, we provide a search function. Users can search coupons based on district, coin range and deal valid till.

```
// search function
    search: function (req, res) {
        const qPage = req.query.page || 1;

        // if (req.method == "POST")
        {
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
            .where({ till: { '>=' : new Date(), '<=' : new Date((qtill == "") ? "12/30/3000" : qtill) } })
            .paginate({ page: qPage, limit: 2 })
            .exec(function (err, visitors) {
                Visitor.count()
                .where({ district: { contains: qdistrict } })
                .where({ coin: { '>=' : startCoin, "<=" : endCoin }})
                .where({ till: { '>=' : new Date(), '<=' : new Date((qtill == "") ? "12/30/3000" : qtill) } })
                .exec(function (err, value) {
                    var pages = Math.ceil(value / 2);
                    return res.view('visitor/search', { 'visitors': visitors, 'count': pages, 'data': data });
                });
            });
        }
        // else
        // {
        //     Visitor.find().paginate({ page: qPage, limit: 2 }).exec(function (err, visitors) {
        //         Visitor.count().exec(function (err, value) {
        //             var pages = Math.ceil(value / 2);
        //             return res.view('visitor/search', { 'visitors': visitors, 'count': pages });
        //         });
        //     });
        // }

    },
```

Under the visitor folder, create a new file named as search.ejs.

```
<!--search.ejs-->
<div class="row">
    <div class="col-12 col-md-8">
        <div class="row">
            <% visitors.forEach( function(model) { %>
            <div class="col-12 col-md-6">
                <div class="container card">
                    <img src="<%= model.image %>" alt="Image" width="100%">
                    <a href="/visitor/detail/<%= model.id %>"><%= model.restaurant %></a>
                    <label><%= model.title %></label>
                    <label>Coins: <%= model.coin %></label>
                </div>
                
                <br>
            </div>
            <% }); %>
        </div>

        <div class="row">
            <% const current = Number(req.query.page || 1); %>

            <nav aria-label="Page navigation example">
                <ul class="pagination">
                    <li class="page-item">
                        <a class="page-link" href="/visitor/search/?page=<%= Math.max(current-1, 1) %>&district=<%= data.district %>&coin=<%= data.coin %>&till=<%= data.till %>">Previous</a>
                    </li>
            
                    <% for (i = 1; i <= count; i++) { %>
                        <li class="page-item">
                            <a class="page-link" href="/visitor/search/?page=<%= i %>&district=<%= data.district %>&coin=<%= data.coin %>&till=<%= data.till %>"><%= i %></a>
                        </li>
                    <% } %>
            
                    <li class="page-item">
                        <a class="page-link" href="/visitor/search/?page=<%= Math.min(current+1, count) %>&district=<%= data.district %>&coin=<%= data.coin %>&till=<%= data.till %>">Next</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
    <div class="col-12 col-md-4">
        <form action="/visitor/search" method="POST">
            <h4>Search</h4>
            <div class="form-group">
                <label>District</label>
                <select class="form-control" name="Visitor[district]">
                    <option value="">Please select one</option>
                    <option value="HK Island" <%= (data.district == "HK Island") ? "selected" : "" %>>HK Island</option>
                    <option value="Kowloon" <%= (data.district == "Kowloon") ? "selected" : "" %>>Kowloon</option>
                    <option value="New Territories" <%= (data.district == "New Territories") ? "selected" : "" %>>New Territories</option>
                </select>
            </div>
            <div class="form-group">
                <label>Coins Range:</label>
                <input type="text" id="coin" name="Visitor[coin]" value="<%= data.coin %>" />
            </div>

            <div class="form-group">
                <label>Deal Valid Till</label>
                <input type="text" class="form-control" name="Visitor[till]" data-provide="datepicker" id="till" value="<%= data.till %>">    
            </div>
            <input type="submit" class="btn btn-primary">
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#search").addClass('active');

        // Coin range
        $("#coin").ionRangeSlider({
            min: 0,
            max: 10000,
            grid: true,
            type: "double",
            prefix: "$"
        });

        // Date picker
        $('#till').datepicker({
            minDate: new Date()
        });
    });
</script>
```

Now, you can restart the server and go to http://localhost:1337/visitor/search to search coupon.

### View latest coupon

Add the following function to your VisitorController.js, inside the braces.

```
// admin function
    admin: function (req, res) {
        Visitor.find().exec(function (err, visitors) {
            return res.view('visitor/admin', { 'visitors': visitors });
        });
    },
```

Under the visitor folder, create a new file named as admin.ejs.

```
<!--admin.ejs-->
<div class="row">
    <table class="table table-striped">
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Rectaurant</th>
            <th></th>
            <th></th>
        </tr>
        <% visitors.forEach( function(model) { %>
        <tr id="<%= (model.till < new Date()) ? "overtime" : "" %>">
            <td class="success"><%= model.id %></td>
            <td><a href="/visitor/detail/<%= model.id %>"><%= model.title %></a></td>
            <td><%= model.restaurant %></td>
            <td><a href="/visitor/update/<%= model.id %>">Update</a></td>
            <td><a href="/visitor/delete/<%= model.id %>">Delete</a></td>
        </tr>
        <% }); %>
    </table>

</div>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#admin").addClass('active');
    });
</script>

<style>
    #overtime {
        background-color: #f2dede !important;
    }
</style>
```

Now, you can restart the server and go to http://localhost:1337/visitor/admin to view all coupons.

### Update coupon

Add the following function to your VisitorController.js, inside the braces.

```
// update function
    update: function (req, res) {
        if (req.method == "POST") {
            Visitor.findOne(req.params.id).exec(function (err, model) {
                model.title = req.body.Visitor.title;
                model.restaurant = req.body.Visitor.restaurant;
                model.district = req.body.Visitor.district;
                model.mall = req.body.Visitor.mall;
                model.image = req.body.Visitor.image;
                model.coin = req.body.Visitor.coin;
                model.till = req.body.Visitor.till;
                model.quota = req.body.Visitor.quota;
                model.details = req.body.Visitor.details;
                model.save();
                return res.view('visitor/message', { 'message' : "Update successfully at " + new Date() + ".", 'menu' : "admin" });
            });
        }
        else {
            Visitor.findOne(req.params.id).exec(function (err, model) {
                if (model == null)
                    return res.view('visitor/message', { 'message': "No such visitor." });
                else
                    return res.view('visitor/update', { 'visitor': model });
            });
        }
    },
```

Under the visitor folder, create a new file named as update.ejs.

```
<!--update.ejs-->
<form action="/visitor/update/<%= visitor.id %>" method="POST">
    <div class="row">
        <div class="col-12 col-md-6">
            <div class="form-group">
                <label>Title:</label>
                <input type="text" class="form-control" name="Visitor[title]" value="<%= visitor.title %>" required>
            </div>
            <div class="form-group">
                <label>Restaurant:</label>
                <input type="text" class="form-control" name="Visitor[restaurant]" value="<%= visitor.restaurant %>" required>
            </div>
            <div class="form-group">
                <label>District:</label>
                <select class="form-control" name="Visitor[district]" id="district" onchange="districtSelected()">
                    <option value="">Please select one</option>
                    <option value="HK Island" <%= (visitor.district == "HK Island") ? "selected" : "" %>>HK Island</option>
                    <option value="Kowloon" <%= (visitor.district == "Kowloon") ? "selected" : "" %>>Kowloon</option>
                    <option value="New Territories" <%= (visitor.district == "New Territories") ? "selected" : "" %>>New Territories</option>
                </select>
            </div>
            <div class="form-group">
                <label>Mall:</label>
                <select class="form-control" name="Visitor[mall]" id="mall">
                    <option value="<%= visitor.mall %>"><%= visitor.mall %></option>
                </select>
            </div>
            <div class="form-group">
                <label>Image:</label>
                <input type="text" class="form-control" name="Visitor[image]" value="<%= visitor.image %>">
            </div>
        </div>

        <div class="col-12 col-md-6">
            <div class="form-group">
                <label>Coin:</label>
                <input type="text" class="form-control" name="Visitor[coin]" value="<%= visitor.coin %>">
            </div>
            <div class="form-group">
                <label>Deal Valid Till</label>
                <input type="text" class="form-control" name="Visitor[till]" data-provide="datepicker" id="till" value="<%= visitor.till %>">
            </div>
            <div class="form-group">
                <label>Quota:</label>
                <input type="number" min="0" class="form-control" name="Visitor[quota]" value="<%= visitor.quota %>">
            </div>
            <div class="form-group">
                <label>Details:</label>
                <textarea class="form-control" rows="4" name="Visitor[details]"><%= visitor.details %></textarea>
            </div>
        </div>
    </div>
    <input type="submit" class="btn btn-primary" value="Update">
</form>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#admin").addClass('active');

        // Date picker
        $('#till').datepicker({
            minDate: new Date()
        });
    });

    // District selector
    var hkIsland = ["IFC", "金鐘太古廣場", "時代廣場", "銅鑼灣世貿中心", "太古城中心", "杏花新城商場", "數碼港商場"];
    var kowloon = ["圓方", "Elements", "Harbour", "City", "海港城", "美麗華商場", "黃埔新天地", "又一城", "朗豪坊商場", "新世紀廣場", "奧海城", "MegaBox", "德福廣場商場", "荷里活廣場", "APM"];
    var newTerritories = ["荃新天地", "荃灣廣場", "悅來坊商場", "綠楊坊商場", "新都會廣場", "青衣城商場", "屯門市廣場", "東港城", "君薈坊商場", "連理街", "沙田新城市廣場", "大埔超級城"];

    function districtSelected() {
        var district = document.getElementById("district").value;

        var mall = document.getElementById("mall");
        mall.options.length = 0;

        if (district == "HK Island")
        {
            for (item of hkIsland)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }

            mall.disabled = false;
        }
        else if (district == "Kowloon")
        {
            for (item of kowloon)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }
            mall.disabled = false;
        }
        else if (district == "New Territories")
        {
            for (item of newTerritories)
            {
                var option = document.createElement("option");
                option.text = item;
                mall.add(option);
            }
            mall.disabled = false;
        }
        else
        {
            mall.disabled = true;
        }
    }

    // Set mall selected
    var mall = $("#mall").val();
    districtSelected();
    $("#mall").val(mall);
</script>
```

Now, you can restart the server and go to http://localhost:1337/visitor/admin to click updating coupon.

### Delete coupon

Add the following function to your VisitorController.js, inside the braces.

```
// delete function
    delete: function(req, res) {
        Visitor.findOne(req.params.id).exec( function(err, model) {
            if (model != null) {
                model.destroy();
                return res.view('visitor/message', { 'message': "Delete successfully at " + new Date() + ".", 'menu' : "admin" });
            } else {
                return res.view('visitor/message', { 'message': "Visitor not found." });
            }
        });
    },
```

Now, you can restart the server and go to http://localhost:1337/visitor/admin to click deleting coupon.

### View details

Add the following function to your VisitorController.js, inside the braces.

```
// view function
    detail: function (req, res) {
        Visitor.findOne(req.params.id).exec(function (err, model) {
            if (model != null)
                return res.view('visitor/detail', { 'visitor': model });
            else
                return res.send("No such visitor");
        });
    },
```

Under the visitor folder, create a new file named as details.ejs.

```
<!--detail.ejs-->
<div class="row">
    <div class="col-12 col-md-5">
        <img src="<%= visitor.image %>" alt="Image" width="100%">
    </div>
    
    <div class="col-12 col-md-7">
        <table class="table table-bordered">
            <tr>
                <td><b><%= visitor.restaurant %></b></td>
            </tr>
            <tr>
                <td><b><%= visitor.title %></b></td>
            </tr>
            <tr>
                <td><b>Coins: </b><%= visitor.coin %></td>
            </tr>
            <tr>
                <td><b>Address: </b><%= visitor.mall %>, <%= visitor.district %></td>
            </tr>
            <tr id="<%= (visitor.till < new Date()) ? "overtime" : "" %>">
                <td><b>Valid Till: </b><%= visitor.till %></td>
            </tr>
            <tr>
                <td><%= visitor.details %></td>
            </tr>
        </table>
    </div>
</div>

<style>
    #overtime {
        background-color: #f2dede !important;
    }
</style>

<script>
    $(document).ready(function () {
        // Set menu actice
        $("#search").addClass('active');
    });
</script>
```

Now, you can restart the server and to view details by clicking the detail links.

## Built With

* [Sails](http://sailsjs.org) - MVC framework

## Versioning

v1.0 

## Authors

* **Jacky Lam**

## License

This project is licensed under by Jacky Lam

## Acknowledgments

* Basic sails function - CRUD
* etc