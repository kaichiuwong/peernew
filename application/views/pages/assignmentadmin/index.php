<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Assignment Management</h1>
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
        <table class="table table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Semester</th>
                    <th>Type</th>
                    <th>Title</th>
                    <th>Group Count</th>
                    <th>Enrolled Students</th>
                    <th>Student Visibility</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($assignments as $a){ ?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['sem']; ?></td>
                    <td><?php echo $a['type'] ? "Group Assignment" : "Individual Assignment"; ?></td>
                    <td><?php echo $a['title']; ?></td>
                    <td><?php echo $a['topic_count']; ?></td>
                    <td><?php echo $a['student_count']; ?></td>
                    <td><?php echo $a['public']?'<i class="fas fa-users"></i> Public':'<i class="fas fa-lock"></i> Private'; ?></td>
                    <td>
                        <?php if ($a['public']): ?>
                        <a href="<?php echo site_url('Assignmentadmin/public_switch/'.$a['id']); ?>" class="btn btn-dark btn-sm">Make Private</a> 
                        <?php else: ?>
                        <a href="<?php echo site_url('Assignmentadmin/public_switch/'.$a['id']); ?>" class="btn btn-success btn-sm">Make Public</a> 
                        <?php endif; ?>
                        <a href="<?php echo site_url('Assignmentadmin/edit/'.$a['id']); ?>" class="btn btn-primary btn-sm">Manage</a> 
                        <a href="<?php echo site_url('Assignmentadmin/remove/'.$a['id']); ?>" class="btn btn-danger btn-sm">Delete</a>
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