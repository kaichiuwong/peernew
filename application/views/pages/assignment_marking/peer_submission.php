<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/group/'.$asg_id); ?>">Group Score</a></li>
          <li class="breadcrumb-item active">Peer Score</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/final_score/'.$asg_id); ?>">Export Score</a></li>
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
                    <th class="align-text-top">Student ID</th>
                    <th class="align-text-top">Username</th>
                    <th class="align-text-top">Student Name</th>
                    <th class="align-text-top">Group</th>
                    <th class="align-text-top">Group Score</th>
                    <th class="align-text-top">Average Peer Score</th>
                    <th class="align-text-top" style="width: 100px;">Status</th>
                    <th class="align-text-top" style="width: 70px;">Override Peer Score</th>
                    <th class="align-text-top">Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($students as $a): ?>
                <tr>
                  <?php echo form_open('Marking/override_peer_mark/',array("class"=>"form-horizontal peer_submission_mark", "data-username" => $a['username'], "id"=>"peer_submission_mark_".$a['username'])); ?>
                    <td><a href="<?php echo site_url('Member/full_profile/'.$a['username']); ?>"><?php echo $a['sid']; ?></a></td>
                    <td><?php echo $a['username']; ?></td>
                    <td><?php echo $a['first_name'] . ' ' . $a['last_name'] ; ?></td>
                    <?php if (empty($a['topic_id'])) : ?>
                      <td class="text-muted">*** Not assign to any groups ***</td>
                      <td></td>
                      <td></td>
                    <?php else: ?>
                      <td><?php echo $a['topic'] ; ?></td>
                      <td><?php echo sprintf("%.2f", $a['group_score']) ; ?></td>
                      <td>
                        <a href="javascript:void(0);" data-username="<?php echo $a['username']; ?>" data-href="<?php echo site_url('Marking/peer_detail/'.$asg_id.'/'.$a['topic_id'].'/'.$a['username']); ?>" class="peer_mark_open"><?php echo sprintf("%.2f", $a['peer_average']) ; ?></a>
                      </td>
                    <?php endif; ?>
                    <td>
                      <?php if ($a['peer_var']>=10) : ?>
                          <span class="text-danger" data-toggle="tooltip" data-placement="top" title="Large score variance between peers"><i class="fas fa-exclamation-triangle"></i></span>
                      <?php endif; ?>
                      <?php if (!empty($a['override_score_remark'])) : ?>
                          <span class="text-success" data-toggle="tooltip" data-placement="top" title="Feedbacks Provided"><i class="fas fa-comment-alt"></i></span>
                      <?php endif; ?>
                      <span class='badge d-none' id="status_<?php echo $a['username']; ?>"></span>
                    </td>
                    <td>
                      <input type="hidden" name="asg_id" value="<?php echo $asg_id;?>" id="asg_id_<?php echo $a['username'];?>" required/>
                      <input type="hidden" name="score_id" value="<?php echo $a['override_score_id'];?>" id="score_id_<?php echo $a['username'];?>" required/>
                      <input type="hidden" name="username" value="<?php echo $a['username'];?>" id="username_<?php echo $a['username'];?>" required/>
                      <input type="number" min="0" step="1" name="score" value="<?php echo $a['override_score'];?>" class="form-control input-sm" id="score_<?php echo $a['username'];?>" required />
                    </td>
                    <td>
                      <button type="button" class="btn btn-primary btn-sm peer_submit_button" data-username="<?php echo $a['username']; ?>" id="submit_btn_<?php echo $a['username']; ?>">Save</button> 
                      <a href="<?php echo site_url('Marking/give_indiv_feedback/'.$asg_id.'/'.$a['topic_id'].'/'.$a['username']); ?>" class="btn btn-info btn-sm">Give Feedbacks</a>
                    </td>
                  <?php echo form_close(); ?>
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
