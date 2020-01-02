<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Create User Profile</h1>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">User Profile</h3>
    </div>
    <?php echo form_open('Member/create/',array("class"=>"user", 'onsubmit'=>'return validatePassword()')); ?>
    <?php if (isset($status)): echo $status; endif;?>
    <div class="card-body">
        <div class="col-lg-12">
              <div class="form-group">
              <label for="Username">Username <?php if (isset($error)): ?><small class="text-danger"><?php echo $error; ?></small><?php endif;?></label>
                <input type="text" value="<?php echo (isset($param['username']))?$param['username']:""; ?>" class="form-control form-control-user" id="username" name="username" placeholder="Username" required>
              </div>
              <div class="form-group row">
                <div class="col-sm-6 mb-3 mb-sm-0">
                  <label for="firstname">First Name</label>
                  <input type="text" value="<?php echo (isset($param['first_name']))?$param['first_name']:""; ?>" class="form-control form-control-user" id="firstname" name="firstname" placeholder="First Name">
                </div>
                <div class="col-sm-6">
                  <label for="lastname">Last Name</label>
                  <input type="text"  value="<?php echo (isset($param['last_name']))?$param['last_name']:""; ?>" class="form-control form-control-user" id="lastname" name="lastname" placeholder="Last Name">
                </div>
              </div>
              <div class="form-group">
                <label for="st_id">Student ID</label>
                <input type="text"  value="<?php echo (isset($param['id']))?$param['id']:""; ?>" class="form-control form-control-user" id="st_id" name="st_id" placeholder="Staff ID">
              </div>
              <div class="form-group">
                <label for="email">Email Address <?php if (isset($emailerror)): ?><small class="text-danger"><?php echo $emailerror; ?></small><?php endif;?></label>
                <input type="email" value="<?php echo (isset($param['email']))?$param['email']:""; ?>" class="form-control form-control-user" id="email" name="email" placeholder="Email Address" required>
              </div>
              <div class="form-group">
                <label for="email">Permission Level</label>
                <select name="plevel" class="form-control form-control-user" required>
                  <option value="" <?php echo (isset($param['plevel']))?"":"seleced"; ?> disabled>*** Permission Level ***</option>
                  <?php if (isset($param['plevel'])): ?>
                    <option value="90" <?php echo ($param['plevel']>=90)?"selected":"" ; ?> ><?php echo get_permission_level_desc(90);?></option>
                    <option value="30" <?php echo ($param['plevel']>=30 && $param['plevel']<90)?"selected":"" ; ?> ><?php echo get_permission_level_desc(30);?></option>
                    <option value="20" <?php echo ($param['plevel']>=20 && $param['plevel']<30)?"selected":"" ; ?> ><?php echo get_permission_level_desc(20);?></option>
                    <option value="10" <?php echo ($param['plevel']>=10 && $param['plevel']<20)?"selected":"" ; ?> ><?php echo get_permission_level_desc(10);?></option>
                    <option value="0" <?php echo ($param['plevel']<10)?"selected":"" ; ?> ><?php echo get_permission_level_desc(0);?></option>
                  <?php else: ?>
                    <option value="90"><?php echo get_permission_level_desc(90);?></option>
                    <option value="30"><?php echo get_permission_level_desc(30);?></option>
                    <option value="20"><?php echo get_permission_level_desc(20);?></option>
                    <option value="10"><?php echo get_permission_level_desc(10);?></option>
                    <option value="0"><?php echo get_permission_level_desc(0);?></option>
                  <?php endif; ?>
                </select>
              </div>
              <div class="form-group row">
                <div class="col-sm-6 mb-3 mb-sm-0">
                  <label for="firstname">Assign Password <small class="text-danger d-none" id="errormsg"><span id="errorContent"></span></small></label>
                  <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="Password" required>
                </div>
                <div class="col-sm-6">
                  <label for="firstname">Repeat password</label>
                  <input type="password" class="form-control form-control-user" id="repeatpassword" placeholder="Repeat Password" required>
                </div>
              </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary btn-sm">Create User</button>
        <a href="<?php echo site_url('Useradministration'); ?>" class="btn btn-secondary btn-sm">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>