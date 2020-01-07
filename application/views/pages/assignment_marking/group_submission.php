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
          <li class="breadcrumb-item active">Group Score</li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('Marking/peer/'.$asg_id); ?>">Peer Score</a></li>
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
        <h3 class="card-title">Group List</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body table-responsive p-3">
        <table class="table table-sm table-head-fixed table-hover enable-datatable">
            <thead>
                <tr>
                    <th class="align-text-top">Group Name</th>
                    <th class="align-text-top">Submission</th>
                    <th class="align-text-top">Submitted by</th>
                    <th class="align-text-top">Submission Time</th>
                    <th class="align-text-top" style="width: 100px;">Status</th>
                    <th class="align-text-top" style="width: 70px;">Score</th>
                    <th class="align-text-top">Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($assignment_topics as $a){ ?>
                <tr>
                  <?php $encode_topic_id = encode_id($a['topic_id']); ?>
                  <?php echo form_open('Marking/save_group_submission/',array("class"=>"form-horizontal grp_submission_mark", "data-grp-id" => $encode_topic_id, "id"=>"grp_submission_mark_".$encode_topic_id)); ?>
                    <td><a href="javascript:void(0);" data-grp-name="<?php echo $a['topic']; ?>" data-href="<?php echo site_url('Assignment/topic_member/'.$encode_topic_id); ?>" class="group_info_open"><?php echo $a['topic']; ?></a></td>
                    <?php if (empty($a['filename'])): ?>
                      <td class="text-muted">No Submission for this group</td>
                      <td></td>
                      <td></td>
                    <?php else: ?>
                      <td><a href="<?php echo base_url().$a['filename']; ?>" target="_blank"><i class="fas fa-file"></i> <?php echo basename($a['filename']); ?></a></td>
                      <td><i class="fas fa-user"></i> <?php echo $a['user_id']; ?></td>
                      <td><i class="fas fa-clock"></i> <?php echo $a['submission_date']; ?> <?php echo ( $a['submission_date'] > $asg_deadline['date_value'] ) ? "<span class='badge badge-danger'>Late Submission</span>": ""; ?> </td>
                    <?php endif; ?>
                      <td>
                        <?php if (!empty($a['remark'])) : ?>
                            <span class="text-success" data-toggle="tooltip" data-placement="top" title="Feedbacks Provided"><i class="fas fa-comment-alt"></i></span>
                        <?php endif; ?>
                        <span class='badge d-none' id="status_<?php echo $encode_topic_id; ?>"></span>
                      </td>
                      <td>
                        <input type="hidden" name="asg_id" value="<?php echo $asg_id;?>" id="asg_id_<?php echo $encode_topic_id;?>" required/>
                        <input type="hidden" name="topic_id" value="<?php echo $encode_topic_id;?>" id="topic_id_<?php echo $encode_topic_id;?>" required/>
                        <input type="hidden" name="score_id" value="<?php echo (empty($a['score_id']))?"": encode_id($a['score_id']);?>" id="score_id_<?php echo $encode_topic_id;?>" required/>
                        <input type="number" min="0" step="1" name="score" value="<?php echo $a['score'];?>" class="form-control input-sm" id="score_<?php echo $encode_topic_id;?>" required />
                      </td>
                      <td>
                        <button type="button" class="btn btn-primary btn-sm grp_submit_button" data-grp-id="<?php echo $encode_topic_id; ?>" id="submit_btn_<?php echo $encode_topic_id; ?>">Save</button> 
                        <a href="<?php echo site_url('Marking/give_group_feedback/'.$asg_id.'/'.$encode_topic_id); ?>" class="btn btn-info btn-sm">Edit Group Feedback</a>
                      </td>
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
