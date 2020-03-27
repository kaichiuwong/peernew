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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Staff_list/index/'.$unit_id); ?>">Staff List</a></li>
          <li class="breadcrumb-item active">Student List</li>
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
        <h3 class="card-title">Student List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($students as $a){ ?>
                <tr>
                    <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['username']; ?></a></td>
                    <td><?php echo $a['sid']; ?></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <td>
                      <span class="text-<?php echo $a['enable'] ? "success":"danger"?>">
                        <b><?php echo $a['enable'] ? "<i class='fas fa-sign-in-alt'></i> Enrolled":"<i class='fas fa-sign-out-alt'></i> Withdrawn"?></b>
                      </span>
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
