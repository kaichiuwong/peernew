<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1>Unit List</h1>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Unit List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
      <?php if (!$readonly) : ?><a href="<?php echo site_url('Unit/add'); ?>" class="btn btn-success btn-sm">Create Unit</a> <?php endif; ?>
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Semester</th>
                    <th>Description</th>
                    <th>Enrolled Student</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <?php foreach($units as $a){ ?>
                <tr>
                    <td><?php echo $a['unit_code']; ?></td>
                    <td><?php echo $a['sem']; ?></td>
                    <td><?php echo $a['unit_description']; ?></td>
                    <td><?php echo $a['std_cnt']; ?></td>
                    <td><span class="text-<?php echo  ( $a['enable'] ? "success":"danger") ; ?>"><b><?php echo  ( $a['enable'] ? "<i class='fas fa-check'></i> Enabled":"<i class='fas fa-times-circle'></i> Disabled") ; ?></b></td>
                    <td>
                        <a href="<?php echo site_url('Assignmentadmin/add/'.encode_id($a['id']) ); ?>" class="btn btn-success btn-sm">Create Assignment</a>
                        <?php if (!$readonly) : ?>
                        <a href="<?php echo site_url('Unit/info/'.encode_id($a['id'])); ?>" class="btn btn-primary btn-sm">Select</a>
                        <a href="<?php echo site_url('Unit/enable_switch/'.encode_id($a['id'])); ?>" class="btn btn-<?php echo  ( $a['enable'] ? "danger":"success") ; ?> btn-sm">
                          <?php echo  ( $a['enable'] ? "Disable":"Enable") ; ?>
                        </a>
                        <a href="<?php echo site_url('Unit/remove/'.encode_id($a['id'])); ?>" class="btn btn-dark btn-sm" onclick="return confirm('*** WARNING ***\nTHIS WILL REMOVE ALL UNIT RELATED RECORDS, INCLUDING ASSIGNMENTS, ASSINGNMENT SUBMISSION, MARKINGS, GROUP ALLOCATION, ASSIGNMENT QUESTIONS etc. \nAre your confirm to remove this UNIT? ');">
                          Remove
                        </a> 
                        <?php endif; ?>
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