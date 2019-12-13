<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>System Users</h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item active">User List</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">User List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Student Name</th>
                    <th>Student ID</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Permission Level</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($user_list as $a){ ?>
                <tr>
                    <td><?php echo $a['username']; ?></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <td><?php echo $a['id']; ?></td>
                    <td><?php echo $a['email']; ?></td>
                    <td><?php echo $a['locked']? "<span class='text-danger text-bold'>Locked</span>":"Normal";?></td>
                    <td><?php echo get_permission_level_desc($a['permission_level']); ?></td>
                    <td>
                    <?php echo form_open('Useradministration/lock/'); ?>
                        <div class="input-group">
                            <input type="hidden" name="username" value="<?php echo $a['username']; ?>" />
                            <span class="input-group-btn">
                                <button class="btn btn-<?php echo $a['locked']? "success":"danger";?> btn-sm" type="submit" tabindex="-1"><?php echo $a['locked']? "Unlock":"Lock";?></button>
                            </span>
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
