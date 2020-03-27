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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_student_list/index/'.$unit_id); ?>">Student List</a></li>
          <li class="breadcrumb-item active">Group Set</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Group Sets</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
      <a href="<?php echo site_url('Unit_group/add/'.$unit_id); ?>" class="btn btn-success btn-sm">Create New Group Set</a> 
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Set Name</th>
                    <th>Number of Groups</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($unit_set as $a){ ?>
                <tr>
                    <td><?php echo $a['desc']; ?></td>
                    <td><?php echo $a['cnt']; ?></td>
                    <td>
                        <a href="<?php echo site_url('Unit_group/edit/'.$unit_id.'/'.encode_id($a['id'])); ?>" class="btn btn-primary btn-sm">Select</a>
                        <a href="<?php echo site_url('Unit_group/remove/'.$unit_id.'/'.encode_id($a['id'])); ?>" class="btn btn-dark btn-sm" onclick="return confirm('Are your confirm to remove this Group Set? ');">
                          Remove
                        </a> 
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