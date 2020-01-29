<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Assignment Marking</h1>
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
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Semester</th>
                    <th>Title</th>
                    <th>Type</th>
                    <th>Feedback Mode</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($assignments as $a):?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['sem']; ?></td>
                    <td><?php echo $a['title']; ?></td>
                    <td><?php echo $a['type'] ? "Group Assignment" : "Individual Assignment"; ?></td>
                    <td><?php echo $a['feedback'] ? '<i class="fas fa-users"></i> Released' : '<i class="fas fa-lock"></i> Private'; ?></td>
                    <td>
                        <a href="<?php echo site_url('Marking/group/'.encode_id($a['asg_id'])); ?>" class="btn btn-primary btn-sm">Select</a>
                        <?php if ($a['feedback']): ?>
                        <a href="<?php echo site_url('Marking/feedback_switch/'.$a['asg_id']); ?>" class="btn btn-dark btn-sm">Close Feedback</a> 
                        <?php else: ?>
                        <a href="<?php echo site_url('Marking/feedback_switch/'.$a['asg_id']); ?>" class="btn btn-success btn-sm" onclick="return confirm('Are your confirm to release the assignment scores and feedbacks to students?');">Release Feedback</a> 
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