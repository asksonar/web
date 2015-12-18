$(function(){
  if ($('#upload-index').length === 0) {
    return;
  }

  Papa.LocalChunkSize = 1048576; // cut it down from 10MB to 1MB for processing

  function processEntireFile(file) {

    var totalProcessedBytes = 0;
    var totalFileBytes = file.size;

    $('.progress-bar').width('5%');

    Papa.parse(file, {
      header: true,
      // skipEmptyLines: true,
      chunk: function(results, parser) {
        var chunkSize = parser.streamer._config.chunkSize;
        var nextChunkStart = parser.streamer._start;
        var chunkStart = nextChunkStart - chunkSize;
        var chunkEnd = Math.min(nextChunkStart, totalFileBytes);

        var chunkBytes = chunkEnd - chunkStart;

        var readRows = parser.streamer._rowCount;

        results.errors.map(function(error) {
          var currentRow = readRows - results.data.length + error.row + 1;
          addStatusWarning('[Row ' + currentRow + '] ' + error.message);
        });

        results.data.forEach(function(element, index, array) {
          if (!element.email) {
            var currentRow = readRows - array.length + index + 1;
            addStatusWarning('[Row ' + currentRow + '] ' + 'Missing field: email is required');
          }
        });

        var dataWithEmail = results.data.filter(function(value) {
          return !!value.email;
        });

        $.ajax({
          type: 'POST',
          url: '/settings/upload',
          data: {
            authenticity_token: AUTH_TOKEN,
            metadata: Papa.unparse(dataWithEmail)
          },
          success: function() {
            totalProcessedBytes += chunkBytes;
            var progress = totalProcessedBytes / totalFileBytes;

            $('.progress-bar').width(
              $('.progress-bar').offsetParent().width() * progress
            );

            var isFinished = progress === 1;
            if (isFinished) {
              $('.progress').fadeOut(1000);
              addStatusSuccess("<div class='bg-success'>File was processed successfully.</div>");
            }
          },
          error: function(jqXHR) {
            addStatusError(jqXHR.responseText);
          }
        });
      },
      complete: function(results, file) {
        // finished processing the whole file
      },
      error: function(error, file) {
        addStatusError("There was an error reading your file: " + error);
      }
    });
  }

  function addStatusWarning(message) {
    addStatus('warning', message);
  }

  function addStatusError(message) {
    addStatus('danger', message);
  }

  function addStatusSuccess(message) {
    addStatus('success', message);
  }

  function addStatus(statusClass, message) {
    $('.status').append("<div class='alert alert-" + statusClass + "'>" + message + "</div>");
  }

  function clearStatus() {
    $('.status').text('');
    $('.progress-bar').width(0);
    $('.progress').show();
  }

  function testBeginningOfFile(evt) {
    clearStatus();

    var file = evt.target.files[0];
    if (file === undefined) {
      return;
    }

    // first check the file
    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      preview: 10,
      complete: function(results) {
        var indexOfEmail = results.meta.fields.indexOf('email');
        if (indexOfEmail >= 0) {
          processEntireFile(file);
        } else {
          addStatusError("Please make sure that there is a column named <code>email</code> in the CSV. ");
        }
      },
      error: function(error, file) {
        addStatusError("There was an error reading your file: " + error);
      }
    });
  }

  $('#file').on('change', testBeginningOfFile);
});
