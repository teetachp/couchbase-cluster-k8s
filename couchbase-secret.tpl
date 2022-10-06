{{ $secret_path := env "VAULT_DATA" }}
kind: Secret
metadata:
  name: cb-auth
type: Opaque
apiVersion: v1
stringData: {{ with $d := $secret_path | parseJSON }}
{{ range $k, $v := $d }}{{ $k | indent 2 }}: {{ $v }}
{{ end }}
{{ end }}
