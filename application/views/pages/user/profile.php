<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">User Profile</h3>
    </div>
    <?php $attributes = array('class' => 'user', 'onsubmit'=>'return validatePassword()'); echo form_open('Setting/update_profile', $attributes); ?>
    <div class="card-body">
        <div class="col-lg-12">
            <div class="alert alert-danger d-none " id="errormsg">
              <small><i class="fas fa-exclamation-triangle"></i> <span id="errorContent"></span></small>
            </div>
            <?php
            if (!empty($update_success)) {
            ?>
            <div class="alert alert-success" id="msgbox">
              <small><i class="fas fa-check-circle"></i> <?php echo $update_success;?></small>
            </div>
            <?php
            }
            ?>
              <div class="form-group">
                <label for="Username">Username</label>
                <input type="text" value="<?php echo $username; ?>" class="form-control form-control-user" id="username" name="username" placeholder="Username" readonly>
              </div>
              <div class="form-group row">
                <div class="col-sm-6 mb-3 mb-sm-0">
                  <label for="firstname">First Name</label>
                  <input type="text" value="<?php echo $firstname; ?>" class="form-control form-control-user" id="firstname" name="firstname" placeholder="First Name">
                </div>
                <div class="col-sm-6">
                  <label for="lastname">Last Name</label>
                  <input type="text"  value="<?php echo $lastname; ?>" class="form-control form-control-user" id="lastname" name="lastname" placeholder="Last Name">
                </div>
              </div>
              <div class="form-group">
                <label for="st_id">Student ID</label>
                <input type="text"  value="<?php echo $st_id; ?>" class="form-control form-control-user" id="st_id" name="st_id" placeholder="Staff ID">
              </div>
              <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" value="<?php echo $email; ?>" class="form-control form-control-user" id="email" name="email" placeholder="Email Address" required>
              </div>
              <div class="form-group">
                <label for="plevel">System Permission Level</label>
                <input type="text" value="<?php echo $permission_level; ?>" class="form-control form-control-user" id="plevel" name="plevel" placeholder="System Permission Level" readonly>
              </div>
              <div class="form-group row">
                <div class="col-sm-6 mb-3 mb-sm-0">
                  <label for="firstname">Update your password <br /><small>(Leave empty if there is no password update)</small></label>
                  <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="Password">
                </div>
                <div class="col-sm-6">
                  <label for="firstname">Repeat password <br />&nbsp;</label>
                  <input type="password" class="form-control form-control-user" id="repeatpassword" placeholder="Repeat Password">
                </div>
              </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary">Update Profile</button>
    </div>
    </form>
</div>