<?php if ($submission_condition['result']): ?>
    <?php if (current_time() > $asg_deadline['date_value']): ?>
        <div class="alert alert-warning" role="alert">
            <span class='text-bold'><i class='fas fa-exclamation-triangle'></i> <?php echo $asg_deadline['description'] ;?> is over.</span><br />
            <span class='text-bold'><?php echo $asg_deadline['description'] ;?></span>: <?php echo $asg_deadline['date_value'] ;?>
        </div>
    <?php else: ?>
        <div class="alert alert-success" role="alert">
            <span class='text-bold'><?php echo $asg_deadline['description'] ;?></span>: <?php echo $asg_deadline['date_value'] ;?>
        </div>
    <?php endif; ?>
<?php else: ?>
    <div class="alert alert-danger" role="alert">
        <?php echo $submission_condition['result']? "":"<span class='text-bold'><i class='fas fa-exclamation-triangle'></i> This section is closed for changes.</span><br />" ;?>
        <?php echo $submission_condition['open_date']? $submission_condition['open_desc']. ": ".$submission_condition['open_date']."<br />" : "" ; ?>
        <?php echo $submission_condition['close_date']? $submission_condition['close_desc']. ": ".$submission_condition['close_date'] : "" ; ?>
    </div>
<?php endif; ?>
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
    <?php if ($submission_condition["result"]) : ?>
        <?php echo form_open_multipart('Assignment/asg_upload_form/'.$asg_id.'/'.encode_id($assignment_topic['topic_id']),array("id"=>"asg_submit_form")); ?>
            <div class="form-group">
            <input type="hidden" value="<?php echo $asg_id; ?>" name="asg_id" />
            <input type="hidden" value="<?php echo encode_id($assignment_topic['topic_id']); ?>" name="grp_id" />
            <input type="hidden" value="<?php echo encode_id($username); ?>" name="username" />
            <label for="assignment_file">Upload Assignment File</label>
            <div class="input-group">
                <div class="custom-file">
                <input type="file" class="custom-file-input" id="assignment_file" name="assignment_file" required>
                <label class="custom-file-label" for="assignment_file"><i class="fas fa-search"></i> Choose file</label>
                <button type="submit" class="d-none" id="asg_submit_button"></button>
                </div>
            </div>
            </div>
        <?php echo form_close(); ?>
    <?php endif; ?>
    <?php if ($submission_hist) { $hist = $submission_hist[0]; ?>
    <h6 class="text-bold">Submitted Assignment</h6>
    <div class="table-responsive">
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
                    <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?> <?php echo ( $hist->submission_date > $asg_deadline['date_value'] ) ? "<span class='badge badge-danger'>Late Submission</span>": ""; ?> </td>
                </tr>                  
            </tbody>
        </table>
    </div>
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
                        <td><i class="fas fa-clock"></i> <?php echo $hist->submission_date; ?> <?php echo ( $hist->submission_date > $asg_deadline['date_value'] ) ? "<span class='badge badge-danger'>Late Submission</span>": ""; ?> </td>
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