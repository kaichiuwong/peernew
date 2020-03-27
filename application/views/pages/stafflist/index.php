<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $unit_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit'); ?>">Unit List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit/info/'.$unit_id); ?>">Info</a></li>
          <li class="breadcrumb-item active">Staff List</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_student_list/index/'.$unit_id); ?>">Student List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_group/index/'.$unit_id); ?>">Group Set</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Staff List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <div class="input-group">
              <?php echo form_open('Staff_list/add/'.$unit_id); ?>
              <select name="username" class="form-control-sm" required>
                  <option value="" disabled selected>*** Staff List ***</option>
                  <?php foreach($uc_list as $user) :?>
                    <option value="<?php echo $user['username']; ?>" >Unit Coordinator - <?php echo $user['first_name']; ?> <?php echo $user['last_name']; ?> (<?php echo $user['username']; ?>)</option>
                  <?php endforeach; ?>
                  <?php foreach($lecturer_list as $user) :?>
                    <option value="<?php echo $user['username']; ?>" >Lecturer - <?php echo $user['first_name']; ?> <?php echo $user['last_name']; ?> (<?php echo $user['username']; ?>)</option>
                  <?php endforeach; ?>
                  <?php foreach($tutor_list as $user) :?>
                    <option value="<?php echo $user['username']; ?>" >Tutor - <?php echo $user['first_name']; ?> <?php echo $user['last_name']; ?> (<?php echo $user['username']; ?>)</option>
                  <?php endforeach; ?>
              </select>
              <span class="input-group-btn">
                  <button class="btn btn-success btn-sm" type="submit" tabindex="-1">Add Staff</button>
                  <input type="hidden" value="<?php echo $unit_id; ?>" name="unit_id" />
              </span>
              <?php echo form_close(); ?>
        </div>
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Staff Name</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php if (!empty($staff)): ?>
                <?php foreach($staff as $a): ?>
                  <?php if (!empty($a['username'])): ?>
                  <tr>
                      <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['username']; ?></a></td>
                      <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                      <td>
                      <?php echo form_open('Staff_list/remove/'.$unit_id); ?>
                          <div class="input-group">
                              <input type="hidden" name="username" value="<?php echo $a['username']; ?>" />
                              <input type="hidden" name="unit_id" value="<?php echo $a['unit_id']; ?>" />
                              <button class="btn btn-danger btn-sm" type="submit"  onclick="return confirm('Are your confirm to remove this staff from this unit?');">Delete</button>
                          </div>
                      <?php echo form_close(); ?>
                      </td>
                  </tr>
                  <?php endif; ?>
                <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
