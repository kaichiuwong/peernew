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
    <?php echo form_open('Member/update/'.$username,array("class"=>"form-horizontal")); ?>
    <div class="card-body">
        <div class="col-lg-12">
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
                <input type="email" value="<?php echo $email; ?>" class="form-control form-control-user" id="email" name="email" placeholder="Email Address" >
              </div>
              <div class="form-group">
                <label for="email">Permission Level</label>
                <select name="plevel" class="form-control form-control-user" required>
                  <option value="" <?php echo (empty($plevel))?"selected":""; ?> disabled>*** Permission Level ***</option>
                  <option value="90" <?php echo ($plevel>=90)?"selected":"" ; ?> >Administrator</option>
                  <option value="30" <?php echo ($plevel>=30 && $plevel<90)?"selected":"" ; ?> >Lecturer</option>
                  <option value="20" <?php echo ($plevel>=20 && $plevel<30)?"selected":"" ; ?> >Tutor</option>
                  <option value="10" <?php echo ($plevel>=10 && $plevel<20)?"selected":"" ; ?> >Student</option>
                  <option value="0" <?php echo ($plevel<10)?"selected":"" ; ?> >Limited User</option>
                </select>
              </div>
        </div>
    </div>
    <div class="card-footer">
        <button type="submit" class="btn btn-primary btn-sm">Save Change</button>
        <a href="<?php echo site_url('Useradministration'); ?>" class="btn btn-secondary btn-sm">Cancel</a>
    </div>
    <?php echo form_close(); ?>
</div>

<?php if ($enroll_unit): ?>
<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Enrolled Unit</h3>
    </div>
    <div class="card-body">
        <div class="col-lg-12">
          <table class="table table-sm table-head-fixed table-hover enable-datatable">
              <thead>
                  <tr>
                      <th>Unit</th>
                      <th>Semester</th>
                      <th>Title</th>
                  </tr>
              </thead>
              <tbody>
              <?php foreach($enroll_unit as $a):  ?>
                  <tr>
                      <td><a href="<?php echo site_url('assignmentadmin/index/'.$a['unit_code']); ?>"><?php echo $a['unit_code']; ?></a></td>
                      <td><?php echo $a['sem']; ?></td>
                      <td><?php echo $a['unit_description']; ?></td>
                  </tr>
              <?php endforeach; ?>
              </tbody>
          </table>
        </div>
    </div>
</div>
<?php endif; ?>

<?php if ($incharge_unit): ?>
<div class="card card-secondary">
    <div class="card-header">
        <h3 class="card-title">Teaching Unit</h3>
    </div>
    <div class="card-body">
        <div class="col-lg-12">
          <table class="table table-sm table-head-fixed table-hover enable-datatable">
              <thead>
                  <tr>
                      <th>Unit</th>
                      <th>Semester</th>
                      <th>Title</th>
                  </tr>
              </thead>
              <tbody>
              <?php foreach($incharge_unit as $a):  ?>
                  <tr>
                      <td><a href="<?php echo site_url('assignmentadmin/index/'.$a['unit_code']); ?>"><?php echo $a['unit_code']; ?></a></td>
                      <td><?php echo $a['sem']; ?></td>
                      <td><?php echo $a['unit_description']; ?></td>
                  </tr>
              <?php endforeach; ?>
              </tbody>
          </table>
        </div>
    </div>
</div>
<?php endif; ?>