<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
  <meta name="description" content="">
  <meta name="author" content="">

  <title><?php echo SYSTEM_FRIENDLY_NAME;?> - Forgot Password</title>

  <!-- Custom fonts for this template-->
  <link href="<?php echo base_url(); ?>/assets/plugins/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Custom styles for this template-->
  <link href="<?php echo base_url(); ?>/assets/dist/css/sb-admin-2.css?t=<?php echo rand(); ?>" rel="stylesheet">

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
                    <h1 class="h4 text-gray-900 mb-2">Forgot Your Password?</h1>
                    <p class="mb-4">Just enter your email address below and we'll send you a link to reset your password!</p>
                  </div>
                  <?php
                  if (!empty($errorMsg)) {
                  ?>
                  <div class="alert alert-danger alert-dismissible fade show" id="errormsg">
                    <small><i class="fas fa-exclamation-triangle"></i> <?php echo $errorMsg; ?></small>
                  </div>
                  <?php
                  }
                  ?>
                  <?php $attributes = array('class' => 'user'); echo form_open('Usercontrol/resetpassword', $attributes); ?>
                    <div class="form-group">
                      <input type="email" name="email" class="form-control form-control-user" id="email" aria-describedby="emailHelp" placeholder="Enter Email Address..." required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-user btn-block"> 
                        Reset Password
                    </button>
                  </form>
                  <hr>
                  <div class="text-center">
                    <a class="small" href="<?php echo base_url(); ?>index.php/Usercontrol/login">Login Again</a>
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
</body>

</html>
