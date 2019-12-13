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
                    <th>Type</th>
                    <th>Title</th>
                    <th>Group Count</th>
                    <th>Enrolled Students</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($assignments as $a){ ?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['type'] ? "Group Assignment" : "Individual Assignment"; ?></td>
                    <td><?php echo $a['title']; ?></td>
                    <td><?php echo $a['topic_count']; ?></td>
                    <td><?php echo $a['student_count']; ?></td>
                    <td>
                        <a href="<?php echo site_url('Assignmentadmin/edit/'.$a['id']); ?>" class="btn btn-info btn-sm">Edit</a> 
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