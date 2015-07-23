module Helpers
  class FfMpegHelper

    def self.wav_webm_to_mp4_webm(input_wav, input_webm, output_mp4, output_webm)
      system_command = "ffmpeg -y -fflags +genpts -i #{input_wav} -i #{input_webm} \
        -shortest -r 24 -vcodec libx264 -acodec libfdk_aac #{output_mp4} \
        -shortest -r 24 -vcodec libvpx -acodec libvorbis #{output_webm}"

      p 'running command: ' + system_command

      if not system system_command
        raise 'Failed to run command: ' + system_command
      end

      p 'finished command: ' + system_command
    end

    def self.webm_to_mp4_webm(input_webm, start_seconds, length_seconds, output_mp4, output_webm)
      system_command = "ffmpeg -y -fflags +genpts -ss #{start_seconds} -i #{input_webm} -t #{length_seconds} \
        -shortest -r 24 -vcodec libx264 -acodec libfdk_aac #{output_mp4} \
        -shortest -r 24 -vcodec libvpx -acodec libvorbis #{output_webm}"

      p 'running command: ' + system_command

      if not system system_command
        raise 'Failed to run command: ' + system_command
      end

      p 'finished command: ' + system_command
    end

    def self.file_length(file_path)
      # truncates decimal
      length_seconds = `ffprobe -i #{file_path} -show_entries format=duration -v quiet -of csv="p=0"`.to_i
    end

    def self.wav_to_flac(input_wav, output_flac, start_seconds, length_seconds)
      system_command = "ffmpeg -y -ss #{start_seconds} -i #{input_wav} -t #{length_seconds} -acodec flac #{output_flac}"

      if not system system_command
        raise 'Failed to run command: ' + system_command
      end
    end

  end
end
