<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>User Profile - <?php echo $username; ?></h1>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">User Profile</h3>
    </div>
    <div class="card-body">
        <div class="col-lg-12">
              <div class="form-group">
                <label for="Username">Username</label>
                <input type="text" value="<?php echo $username; ?>" class="form-control form-control-user" id="username" name="username" placeholder="Username" readonly>
              </div>
              <div class="form-group row">
                <div class="col-sm-6 mb-3 mb-sm-0">
                  <label for="firstname">First Name</label>
                  <input type="text" value="<?php echo $firstname; ?>" class="form-control form-control-user" id="firstname" name="firstname" placeholder="First Name" readonly>
                </div>
                <div class="col-sm-6">
                  <label for="lastname">Last Name</label>
                  <input type="text"  value="<?php echo $lastname; ?>" class="form-control form-control-user" id="lastname" name="lastname" placeholder="Last Name" readonly>
                </div>
              </div>
              <div class="form-group">
                <label for="st_id">SID</label>
                <input type="text"  value="<?php echo $st_id; ?>" class="form-control form-control-user" id="st_id" name="st_id" placeholder="SID" readonly>
              </div>
              <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" value="<?php echo $email; ?>" class="form-control form-control-user" id="email" name="email" placeholder="Email Address" readonly >
              </div>
        </div>
    </div>
</div>