function result = get_frame(filename, frame)

object = VideoReader(filename);
result = read(object, frame);
