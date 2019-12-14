<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/group/'.$asg_id); ?>">Groups</a></li>
          <li class="breadcrumb-item active">Submission</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <?php if (!$allow_submit) :?>
    <div class="card">
      <div class="card-header bg-danger">
        <h3 class="card-title text-bold"><i class="fas fa-exclamation-triangle"></i> No Assignment Group Found.</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body">
            You need to select an assignment group before submit any assignment.
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
    <?php else: ?>
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part A</span> Submission</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <ul class="nav nav-tabs" id="custom-content-above-tab" role="tablist">
              <li class="nav-item">
                <a class="nav-link active" id="submission-info-tab" data-toggle="pill" href="#submission-info" role="tab" aria-controls="submission-info" aria-selected="true"><i class="fas fa-file-upload"></i> Upload Assignment</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="history-info-tab" data-toggle="pill" href="#history-info" role="tab" aria-controls="history-info" aria-selected="false"><i class="fas fa-history"></i> Submission History</a>
              </li>
            </ul>
            <div class="tab-content" id="custom-content-above-tabContent">
              <div class="tab-pane fade show active" id="submission-info" role="tabpanel" aria-labelledby="submission-info-tab">
                <?php echo form_open_multipart('assignment/submit/'.$asg_id); ?>
                  <div class="form-group">
                    <input type="hidden" value="<?php echo $asg_id; ?>" name="asg_id" />
                    <input type="hidden" value="<?php echo $assignment_topic['topic_id']; ?>" name="grp_id" />
                    <input type="hidden" value="<?php echo $username; ?>" name="username" />
                    <label for="assignment_file">Upload Assignment File</label>
                    <div class="input-group">
                      <div class="custom-file">
                        <input type="file" class="custom-file-input" id="assignment_file" name="assignment_file" required>
                        <label class="custom-file-label" for="assignment_file"><i class="fas fa-search"></i> Choose file</label>
                      </div>
                      <div class="input-group-append">
                        <button type="submit" class="input-group-text" id=""><i class="fas fa-file-upload"></i> Upload</button>
                      </div>
                    </div>
                  </div>
                <?php echo form_close(); ?>
                <?php if ($submission_hist) { $hist = $submission_hist[0]; ?>
                <h6 class="text-bold">Submitted Assignment</h6>
                <table class="table table-sm table-head-fixed table-hover">
                    <thead>
                        <tr>
                            <th>File</th>
                            <th>Submitted by</th>
                            <th>Submission Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><i class="fas fa-file"></i> <a href="<?php echo base_url().$hist->filename; ?>" target="_blank"><?php echo basename($hist->filename); ?></a></td>
                            <td><i class="fas fa-user"></i> <?php echo $hist->user_id; ?></td>
                            <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?></td>
                        </tr>                  
                    </tbody>
                </table>
                <?php } ?>
              </div>
              <div class="tab-pane fade" id="history-info" role="tabpanel" aria-labelledby="history-info-tab">
                    <table class="table table-sm table-head-fixed table-hover">
                        <thead>
                            <tr>
                                <th>File</th>
                                <th>Submit by</th>
                                <th>Submission Time</th>
                            </tr>
                        </thead>
                        <tbody>
                          <?php if ($submission_hist) : ?>
                            <?php foreach ($submission_hist as $hist) : ?>
                                <tr>
                                    <td><i class="fas fa-file"></i> <a href="<?php echo base_url().$hist->filename; ?>" target="_blank"><?php echo basename($hist->filename); ?></a></td>
                                    <td><i class="fas fa-user"></i> <?php echo $hist->user_id; ?></td>
                                    <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?></td>
                                </tr>
                            <?php endforeach; ?>
                          <?php else: ?>
                                <tr>
                                </tr>
                          <?php endif; ?>
                        </tbody>
                    </table>
              </div>
            </div>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card -->
    
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part B</span> Self Evaluation Questions</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body" id="self_feedback_card" data-href="<?php echo site_url('Assignment/self_feedback_form/'.$asg_id.'/'.$assignment_topic['topic_id']); ?>">

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="button" class="btn btn-primary btn-sm" id="btn_self_submit">Save</button>
        </div>
        <div class="overlay dark" id="loading-self-feedback-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
    </div>
    <!-- /.card -->
    

    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part C</span> Peer Review</h3>
        </div>
        <!-- /.card-header -->
        
        <div class="card-body" id="peer_feedback_card" data-href="<?php echo site_url('Assignment/peer_feedback_form/'.$asg_id.'/'.$assignment_topic['topic_id']); ?>">

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="button" class="btn btn-primary btn-sm" id="btn_peer_submit">Save</button>
        </div>
        <div class="overlay dark" id="loading-peer-feedback-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
    </div>
    <!-- /.card -->
    <?php endif; ?>
  </div>
</div>
<!-- /.row -->