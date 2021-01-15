provider "wavefront" {
  address = "https://vmware.wavefront.com"
  token = "fea4e2f4-03f9-4119-adad-c4c0ba9b2034"
}

resource "wavefront_dashboard" "kubernetes_log" {
   name = "Kubernetes Log Monitoring Dashboard"
   description = "Kubernetes Log Monitoring Dashboard"
   url = "klog"
   parameter_details {
      name = "cluster_name"
      label = "cluster_name"
      default_value = "*"
      hide_from_view = false
      parameter_type = "DYNAMIC"
      query_value = "collect(max(ts(\"kubernetes.cluster.cpu.limit\"), cluster), taggify(1, cluster, \"*\"))"
      dynamic_field_type = "POINT_TAG"
   }
   section {
     name = "Standard Out"
     row {
         chart {
            name = "Top STDOUT logs"
            description = "Top STDOUT logs"
            units = "Top STDOUT logs"
            source {
              name = "stdout"
              query = "limit(30, highpass(0, round(at('end',msum(1vw, rawsum(ts('kubernetes.container.logs.stdout.counter' , cluster=\"${cluster_name}\"),pod))))))"
            }
            chart_setting {
                type = "top-k"
            }
         }
         chart {
            name = "STDOUT logs per miniute"
            description = "STDOUT logs per miniute"
            units = "STDOUT logs per miniute"
            source {
              name = "stdout"
              query = "mdiff(1m,ts(\"kubernetes.container.logs.stdout.counter\", cluster=\"${cluster_name}\" ))"
            }
            chart_setting {
                type = "line"
            }
         }
     }
   }
   section {
     name = "Standard Error"
     row {
         chart {
            name = "Top STDERR logs"
            description = "Top STDERR logs"
            source {
              name = "stdout"
              query = "limit(30, highpass(0, round(at('end',msum(1vw, rawsum(ts(\"kubernetes.container.logs.stderr.counter\" , cluster=\"${cluster_name}\"),pod))))))"
            }
            chart_setting {
                type = "top-k"
            }
         }
         chart {
            name = "STDERR logs per miniute"
            description = "STDERR logs per miniute"
            units = "STDERR logs per miniute"
            source {
              name = "stdout"
              query = "mdiff(1m,ts(\"kubernetes.container.logs.stderr.counter\", cluster=\"${cluster_name}\" ))"
            }
            chart_setting {
                type = "line"
            }
         }
     }
   }
}
