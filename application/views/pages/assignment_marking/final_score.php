<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/group/'.$asg_id); ?>">Group Score</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/peer/'.$asg_id); ?>">Peer Score</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/default_feedback/'.$asg_id); ?>">Default Feedback</a></li>
          <li class="breadcrumb-item active">Export Score</li>
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
        <a href="<?php echo site_url('Marking/export_score/'.$asg_id); ?>" class="btn btn-sm btn-success">Export to Excel</a>
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th class="align-text-top">Student ID</th>
                    <th class="align-text-top">Username</th>
                    <th class="align-text-top">Student Name</th>
                    <th class="align-text-top">Group</th>
                    <th class="align-text-top">Group Score</th>
                    <th class="align-text-top">Peer Score</th>
                    <th class="align-text-top">Total Score</th>
                    <th class="align-text-top">Remarks</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($students as $a): ?>
                <tr>
                    <td><?php echo $a['sid']; ?></td>
                    <td><?php echo $a['username']; ?></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <?php if (empty($a['topic_id'])) : ?>
                      <td class="text-muted">*** Not assign to any groups ***</td>
                      <td><?php echo sprintf("%.2f", $a['group_score']) ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['peer_score']) ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['total_score']) ; ?></td>
                    <?php else: ?>
                      <td><?php echo $a['topic'] ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['group_score']) ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['peer_score']) ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['total_score']) ; ?></td>
                    <?php endif; ?>
                    <?php if ( $a['enable'] == 0 ): ?>
                      <td>Student has withdrawn this unit.</td>
                    <?php else: ?>
                      <td></td>
                    <?php endif;?>
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
