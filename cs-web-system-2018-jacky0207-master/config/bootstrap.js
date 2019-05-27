/**
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#!/documentation/reference/sails.config/sails.config.bootstrap.html
 */

module.exports.bootstrap = function (cb) {

  // It's very important to trigger this callback method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
  
  // Initialize users
  // Load the bcrypt module
  sails.bcrypt = require('bcrypt');

  // Go through a series of rounds to give you a secure hash
  const saltRounds = 10;

  // User.find().exec(function (err, users) {
  //   users.forEach(function(model) {
  //     model.destroy();
  //   });
  // });

  User.count().exec(function (err, count) {

      if (count == 0)
      {

          var users = [
              { "username": "admin", "password": "123456", "role": "admin" },
              { "username": "user", "password": "password", "coin": 1000 },
              { "username": "jacky", "password": "asdfasdf", "coin": 1000 },
              { "username": "tom", "password": "asdfasdf", "coin": 1000 }
          ];

          users.forEach(function (user) {

              user.password = sails.bcrypt.hashSync(user.password, saltRounds);

              User.create(user).exec(function (err, model) {
              
                  // if ( err ) {
                  //     console.log(err);
                  //     return;
                  // }
          
                  // user.id = model.id;

                  // if (model.id == users[0].id) {
                  //     model.supervises.add(persons[0].id);  // the id for kenny
                  // }

                  // if (model.username == users[1].id) {
                  //     model.supervises.add(persons[0].id);  // the id for martin
                  //     model.supervises.add(persons[1].id);  // the id for kenny
                  // }

                  // model.save();

              });

          });

      }

  })

  cb();
};
