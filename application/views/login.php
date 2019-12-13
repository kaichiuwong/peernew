<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Peer Assessment System - Login</title>

  <!-- Custom fonts for this template-->
  <link href="<?php echo base_url(); ?>/assets/plugins/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="<?php echo base_url(); ?>/assets/dist/css/sb-admin-2.css" rel="stylesheet">

</head>

<body class="bg-gradient-dark">

  <div class="container">

    <!-- Outer Row -->
    <div class="row justify-content-center">

      <div class="col-xl-6 col-lg-12 col-md-9">

        <div class="card o-hidden border-0 shadow-lg my-5">
          <div class="card-body p-0">
            <!-- Nested Row within Card Body -->
            <div class="row">
              <div class="col-lg-12">
                <div class="p-5">
                  <div class="text-center">
                    <h1 class="h4 text-gray-900 mb-4">Peer Assessment System</h1>
                  </div>
                  <?php
                  if (!empty($error_message)) {
                  ?>
                  <div class="alert alert-danger alert-dismissible fade show" id="errormsg">
                    <small><i class="fas fa-exclamation-triangle"></i> <?php echo $error_message; ?></small>
                  </div>
                  <?php
                  }
                  ?>
                  <?php
                  if (!empty($info_message)) {
                  ?>
                  <div class="alert alert-success" id="infomsg">
                    <small><i class="fas fa-check-circle"></i> <?php echo $info_message; ?></small>
                  </div>
                  <?php
                  }
                  ?>
                  <?php $attributes = array('class' => 'user'); echo form_open('Usercontrol/login', $attributes); ?>
                    <div class="form-group">
                      <input type="text" class="form-control form-control-user" id="username" name="username" placeholder="Username" required>
                    </div>
                    <div class="form-group">
                      <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="Password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-user btn-block"> 
                        Login
                    </button>
                  </form>
                  <hr>
                  <div class="text-center">
                    <a class="small" href="<?php echo base_url(); ?>index.php/Usercontrol/forgotpassword">Forgot Password?</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>

  </div>

  <!-- Bootstrap core JavaScript-->
  <script src="<?php echo base_url(); ?>/assets/plugins/jquery/jquery.min.js"></script>
  <script src="<?php echo base_url(); ?>/assets/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="<?php echo base_url(); ?>/assets/plugins/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="<?php echo base_url(); ?>/assets/dist/js/sb-admin-2.js"></script>
  <script src="<?php echo base_url(); ?>/assets/dist/js/pas.js"></script>

</body>

</html>
