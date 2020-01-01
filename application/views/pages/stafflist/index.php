<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Student_list/index/'.$asg_id); ?>">Student List</a></li>
          <li class="breadcrumb-item active">Staff List</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
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
              <?php echo form_open('Staff_list/add/'.$asg_id); ?>
              <select name="username" class="form-control-sm" required>
                  <option value="" disabled selected>*** Staff List ***</option>
                  <?php foreach($lecturer_list as $user) :?>
                    <option value="<?php echo $user['username']; ?>" >Academic Staff - <?php echo $user['first_name']; ?> <?php echo $user['last_name']; ?> (<?php echo $user['username']; ?>)</option>
                  <?php endforeach; ?>
                  <?php foreach($tutor_list as $user) :?>
                    <option value="<?php echo $user['username']; ?>" >Tutor - <?php echo $user['first_name']; ?> <?php echo $user['last_name']; ?> (<?php echo $user['username']; ?>)</option>
                  <?php endforeach; ?>
              </select>
              <span class="input-group-btn">
                  <button class="btn btn-success btn-sm" type="submit" tabindex="-1">Add Staff</button>
                  <input type="hidden" value="<?php echo $asg_id; ?>" name="asg_id" />
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
                <?php foreach($staff as $a){ ?>
                <tr>
                    <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['username']; ?></a></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <td>
                    <?php echo form_open('Staff_list/remove/'.$asg_id); ?>
                        <div class="input-group">
                            <input type="hidden" name="username" value="<?php echo $a['username']; ?>" />
                            <input type="hidden" name="asg_id" value="<?php echo $a['asg_id']; ?>" />
                            <button class="btn btn-danger btn-sm" type="submit"  onclick="return confirm('Are your confirm to remove this staff from this unit?');">Delete</button>
                        </div>
                    <?php echo form_close(); ?>
                    </td>
                </tr>
                <?php } ?>
            </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
