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
          <li class="breadcrumb-item active">Group Score</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/peer/'.$asg_id); ?>">Peer Score</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/final_score/'.$asg_id); ?>">Final Score</a></li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>


<div class="row">
  <div class="col-12">
    <div class="card card-secondary">
      <div class="card-header">
        <h3 class="card-title">Group List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th>Group Name</th>
                    <th>Submission</th>
                    <th>Submitted by</th>
                    <th>Submission Time</th>
                    <th style="width: 70px;">Score</th>
                    <th style="width: 150px;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($assignment_topics as $a){ ?>
                <tr>
                  <?php echo form_open('Marking/save_group_submission/',array("class"=>"form-horizontal grp_submission_mark", "data-grp-id" => $a['topic_id'], "id"=>"grp_submission_mark_".$a['topic_id'])); ?>
                    <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['topic']; ?>" data-href="<?php echo site_url('assignment_topic/topic_member/'.$a['topic_id']); ?>" class="group_info_open"><?php echo $a['topic']; ?></a></td>
                    <?php if (empty($a['filename'])): ?>
                      <td class="text-muted">No Submission for this group</td>
                      <td></td>
                      <td></td>
                      <td>
                        <input type="hidden" name="asg_id" value="<?php echo $asg_id;?>" id="asg_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="topic_id" value="<?php echo $a['topic_id'];?>" id="topic_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="score_id" value="<?php echo $a['score_id'];?>" id="score_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="remark" value="<?php echo $a['remark'];?>" id="remark_<?php echo $a['topic_id'];?>"/>
                        <input type="number" min="0" step="1" name="score" value="<?php echo $a['score'];?>" class="form-control input-sm" id="score_<?php echo $a['topic_id'];?>" required />
                      </td>
                      <td>
                        <button type="button" class="btn btn-info btn-sm grp_submit_button" data-grp-id="<?php echo $a['topic_id']; ?>" id="submit_btn_<?php echo $a['topic_id']; ?>">Save</button> 
                        <span class='badge d-none' id="status_<?php echo $a['topic_id']; ?>"></span>
                      </td>
                    <?php else: ?>
                      <td><a href="<?php echo base_url().$a['filename']; ?>" target="_blank"><i class="fas fa-file"></i> <?php echo basename($a['filename']); ?></a></td>
                      <td><i class="fas fa-user"></i> <?php echo $a['user_id']; ?></td>
                      <td><i class="fas fa-clock"></i> <?php echo $a['submission_date']; ?> <?php echo ( $a['submission_date'] > $asg_deadline['date_value'] ) ? "<span class='badge badge-danger'>Late Submission</span>": ""; ?> </td>
                      <td>
                      <input type="hidden" name="asg_id" value="<?php echo $asg_id;?>" id="asg_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="topic_id" value="<?php echo $a['topic_id'];?>" id="topic_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="score_id" value="<?php echo $a['score_id'];?>" id="score_id_<?php echo $a['topic_id'];?>" required/>
                        <input type="hidden" name="remark" value="<?php echo $a['remark'];?>" id="remark_<?php echo $a['topic_id'];?>"/>
                        <input type="number" min="0" step="1" name="score" value="<?php echo $a['score'];?>" class="form-control input-sm" id="score_<?php echo $a['topic_id'];?>" required />
                      </td>
                      <td>
                        <button type="button" class="btn btn-info btn-sm grp_submit_button" data-grp-id="<?php echo $a['topic_id']; ?>" id="submit_btn_<?php echo $a['topic_id']; ?>">Save</button> 
                        <span class='badge d-none' id="status_<?php echo $a['topic_id']; ?>"></span>
                      </td>
                    <?php endif; ?>
                    <?php echo form_close(); ?>
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
