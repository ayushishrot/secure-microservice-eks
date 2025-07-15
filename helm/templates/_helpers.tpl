{{- define "chart.name" -}}
{{ .Values.global.appName | default "web-app" }}
{{- end }}

{{- define "chart.labels" -}}
app.kubernetes.io/name: {{ include "chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

