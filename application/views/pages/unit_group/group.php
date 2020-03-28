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
          <li class="breadcrumb-item"><a href="<?php echo site_url('Unit_group/index/'.$unit_id); ?>">Group Set</a></li>
          <li class="breadcrumb-item active">Group List</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Group List of <?php echo $set_info['desc']; ?></h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
	  <a href="<?php echo site_url('Unit_group/add_group/'.$unit_id.'/'.$set_id); ?>" class="btn btn-success btn-lg" data-toggle="tooltip" data-placement="top" title="Create extra groups under this set"><i class="fas fa-user-plus"></i></a> 
    <a href="<?php echo site_url('Unit_group/student_list/'.$unit_id.'/'.$set_id); ?>" class="btn btn-primary btn-lg" data-toggle="tooltip" data-placement="top" title="View student list"><i class="fas fa-list"></i></a>
      <?php if (count($student_no_grp) == 0): ?>
        <a href="javascript:void(0);" class="btn btn-success btn-lg" data-toggle="tooltip" data-placement="top" title="All students has a group">0 <i class="far fa-smile"></i></a>
      <?php else: ?>
        <a href="javascript:void(0);" data-grp-name="Students without group" data-href="<?php echo site_url('Unit_group/student_no_group/'.$unit_id.'/'.$set_id); ?>" class="group_info_open btn btn-warning btn-lg" data-toggle="tooltip" data-placement="top" title="<?php echo count($student_no_grp); ?> students without group"><?php echo count($student_no_grp); ?> <i class="far fa-sad-tear"></i></a>
      <?php endif; ?>
      <a href="<?php echo site_url('Unit_group/random/'.$unit_id.'/'.$set_id); ?>" class="btn btn-warning btn-lg" data-toggle="tooltip" data-placement="top" title="Randomly assign students without group to a group"><i class="fas fa-dice"></i></a>
      <a href="<?php echo site_url('Unit_group/clear_allocation/'.$unit_id.'/'.$set_id); ?>" class="btn btn-danger btn-lg" data-toggle="tooltip" data-placement="top" title="Clear groups allocation"><i class="fas fa-broom"></i></a>
      <a href="<?php echo site_url('Unit_group/clear_groups/'.$unit_id.'/'.$set_id); ?>" class="btn btn-danger btn-lg" data-toggle="tooltip" data-placement="top" title="Remove all groups"><i class="fas fa-eraser"></i></a>
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Group Name</th>
                    <th>Group Members</th>
                    <th>Capacity</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($group_list as $a): ?>
                <tr>
                    <td><?php echo $a['group_name']; ?></td>
                    <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['group_name']; ?>" data-href="<?php echo site_url('Unit_group/group_member/'.encode_id($a['id'])); ?>" class="group_info_open"><?php echo $a['cnt']; ?></a></td>
                    <td><?php echo $a['max']; ?></td>
                    <td>
                        <a href="<?php echo site_url('Unit_group/remove_group/'.$unit_id.'/'.$set_id.'/'.encode_id($a['id'])); ?>" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="Remove this Group" onclick="return confirm('Are your confirm to remove this Group? ');"><i class="far fa-trash-alt"></i></a> 
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
</div>
<!-- /.row -->
