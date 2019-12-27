<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo ($unit)?$unit." - " : ""; ?>Assignment Management</h1>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Assignment List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
      <a href="<?php echo site_url('Assignmentadmin/add'); ?>" class="btn btn-success btn-sm">Create Assignment</a> 
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Semester</th>
                    <th>Title</th>
                    <th>Type</th>
                    <th>Group Count</th>
                    <th>Enrolled Students</th>
                    <th>Student Visibility</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($assignments as $a):?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['sem']; ?></td>
                    <td><a href="<?php echo site_url('Assignmentadmin/info/'.$a['id']); ?>"><?php echo $a['title']; ?></a></td>
                    <td><?php echo $a['type'] ? "Group Assignment" : "Individual Assignment"; ?></td>
                    <td><a href="<?php echo site_url('Assignment_topic/index/'.$a['id']); ?>"><?php echo $a['topic_count']; ?></a></td>
                    <td><a href="<?php echo site_url('Student_list/index/'.$a['id']); ?>"><?php echo $a['student_count']; ?></a></td>
                    <td><?php echo $a['public']?'<i class="fas fa-users"></i> Public':'<i class="fas fa-lock"></i> Private'; ?></td>
                    <td>
                        <a href="<?php echo site_url('Assignmentadmin/remove/'.$a['id']); ?>" class="btn btn-danger btn-sm" onclick="return confirm('Are your confirm to remove this assignment?');">Delete</a>
                        <?php if ($a['public']): ?>
                        <a href="<?php echo site_url('Assignmentadmin/public_switch/'.$a['id']); ?>" class="btn btn-dark btn-sm">Make Private</a> 
                        <?php else: ?>
                        <a href="<?php echo site_url('Assignmentadmin/public_switch/'.$a['id']); ?>" class="btn btn-success btn-sm" onclick="return confirm('Are your confirm to release this assignment to students?');">Make Public</a> 
                        <?php endif; ?>
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