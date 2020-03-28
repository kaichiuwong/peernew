<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $asg_header; ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Assignmentadmin/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_date/index/'.$asg_id); ?>">Timeline</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_topic/index/'.$asg_id); ?>">Group List</a></li>
          <li class="breadcrumb-item active">Student List</li>
          
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/self'; ?>">Self Evaluation</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment_question/index/'.$asg_id).'/peer'; ?>">Peer Review</a></li>
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
                    <th>Group</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($students as $a){ ?>
                <tr>
                    <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['username']; ?></a> <?php if ($a['enable'] == 0) : ?><span class="badge badge-danger">Withdrawn</sapn><?php endif; ?></a</td>
                    <td><?php echo $a['sid']; ?></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <td>
                    <?php echo form_open('student_list/assign_grp/'); ?>
                        <div class="input-group">
                            <input type="hidden" name="ata_id" value="<?php echo $a['ata_id']; ?>" />
                            <input type="hidden" name="user_id" value="<?php echo $a['username']; ?>" />
                            <input type="hidden" name="asg_id" value="<?php echo $a['asg_id']; ?>" />
                            <select name="group_id" class="form-control-sm" required <?php if ($a['enable'] == 0) : ?> disabled <?php endif; ?> >
                                <option value="" disabled selected>*** Not Assigned to Groups ***</option>
                                <?php foreach($group_list as $g){ ?>
                                <option value="<?php echo $g['id']; ?>" <?php echo ($g['id'] == $a['topic_id'])? "selected":"" ;?> <?php echo ($g['cnt'] >= $g['max'])? "disabled":"" ;?>><?php echo $g['topic'] . ' ('.$g['cnt'].'/'.$g['max'].')'; ?></option>
                                <?php }?>
                            </select>
                            <span class="input-group-btn">
                                <button class="btn btn-primary btn-sm" type="submit" tabindex="-1" <?php if ($a['enable'] == 0) : ?> disabled <?php endif; ?> >Assign</button>
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
