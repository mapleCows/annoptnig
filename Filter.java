import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;


/**
 * Filter log file by response code
 */
public class Filter {
    public static class TokenizerMapper
            extends Mapper<LongWritable, Text, NullWritable, Text> {
            private String desiredResponse;
        @Override
        protected void setup(Context context) throws IOException, InterruptedException {
            super.setup(context);
            // TODO add additional setup to your map task, if needed
            Configuration conf = context.getConfiguration();
            System.out.print(context.getConfiguration().get("dr"));
            this.desiredResponse = conf.get("dr") ;
           // System.out.print(this.desiredResponse);
        }

        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            if (key.get() == 0)
                return; // Skip header line
            String[] parts = value.toString().split("\t");
            String responseCode = parts[5];
            if (responseCode.equals(this.desiredResponse))
                context.write(NullWritable.get(), value);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String desiredResponse = args[2];
        conf.set("dr", desiredResponse);
        Job job = Job.getInstance(conf, "filter");
        job.setJarByClass(Filter.class);
        job.setMapperClass(TokenizerMapper.class);
        job.setNumReduceTasks(0);
        job.setInputFormatClass(TextInputFormat.class);
        Path input = new Path(args[0]);
        FileInputFormat.addInputPath(job, input);
        Path output = new Path(args[1]);
        FileOutputFormat.setOutputPath(job, output);


       // System.out.print(conf.get("dr"));
        // TODO pass the desiredResponse code to the MapReduce program

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}