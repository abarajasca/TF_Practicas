# Get Started - Terraform

## Cheat-Sheet
1. terraform.tf     - File containing HCL(Hashicorp Configuration Language) code about the configuration we want.

```
resource "local_file" "productos" {
  content = "Lista de Productos"
  filename = "productos.txt"
}
```

2. terraform **init**   - Download all provideres required.

1. terraform **plan** [--out plan_to_save]  - Show a plan about what will be do. and saved if --out option is defined.

1. terraform **apply** \
    [ plan_file ] - Run a plan and apply it. if file name is specified the plan saved is used. \
    [ --auto-approve=true ]  - Apply changes without ask for approve. \
    [ --target resource ]  - Deploy only resource specified. \
    [ --replace=instance_or_resource ]    - replace specific object with current code ( destroy and apply for the resource)

1. terraform **destroy** - Destroy all resources defined in state file.\
[ --auto-approve=true ]  - Apply changes without ask for approve. (not recommended) 

1. Referencing a resource in another resource. ${ resource.name.results}
```
filename = "productos-${random_string.sufijo.id}.txt"
```

7. terraform **show**   - See resources created.\
[plan_file]     - Show the plan saved.

9. terraform **fmt** [file]        - Apply format to all or specified file. 

10. terraform **validate**          - check correct syntaxis in tf files.

11. Variables
```
  variable "virginia_cidr" {
    default = "10.0.0.0/16"
  }
```
  Use of the variable:
```
  resource "aws_vpc" "virginia_vcp" {
    cidr_block = var.virginia_cidr
  }
  
```

If default is not defined terraform will prompt to the user.

We can use environment variables using prefix  "TF_VAR_" and the name of the expected variable.
```
TF_VAR_virginia_vcp
```

variable can be set as parameter during call of the plan:
```
terraform plan -var ohio_cidr="10.20.0.0/16"
```

- Split definitions of vars in [ variables.tf ] and set the values in [ terraform.tfvars/terraform.tfvars.json ] / *.auto.tfvars | *.auto.tfvars.json
```
variables.tf:
variable "my_variable" {  
}


terraform.tfvars:
my_variable="my value"
```

12. Variable precedences 1.- most 5 .- less
```
1 .- Command line : -var variable="value"
2 .- *.auto.tfvars
3 .- terraform.tfvars
4 .- environment variables ( TF_VT_ )
```

13. Types of variables
```
variable "virginia_cidr" {
  default     = "10.10.0.0./16"
  description = "CIDR de la VPC de Virginia"
  type        = string
  sensitive   = true            / Value is not show is screen.
}
```

14. Variable types:
```
string : "10.0.0.0/16"
number : 1
bool   : true/false
list   : ["abc","def"]
map    : { "v1": "v2" }
set    : ["one","two"]
any    : Any type
```

15. Variable conversions:
```
  String -> Number
  Number -> String
  String  -> Boolean
  Boolean -> String

``` 

16. List type based on initial index equal 0
```
variable "lista_cidrs" {
  default = ["10.10.0.0/16","10.20.0.0/16"]
  type    = list(string)
}

Use:

resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.lista_cidr[0]
}
```

17. Map Type
```
variable "map_cidrs" {
  default = {
     "virginia"  = "10.10.0.0/16"
     "ohio"      = "10.20.0.0/16"

  type    = map(string)
}

Use:

resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.map_cidrs["virginia"]
}
```
 
18. Set Type  - Not allow duplicate values , we can't use index to acces to it.
```
variable "set_cidrs" {
  default = ["10.10.0.0/16","10.20.0.0/16"]

  type    = set(string)
}

Use:

resource "aws_vpc" "vpc_virginia" {
  for_each   = var.set_cidrs
  cidr_block = each.value
}
```

19. Object Type 
```
variable "virginia" {
  type = object({
    nombre     = string
    cantidad   = number
    cidrs      = list(string)
    disponible = bool
    env        = string
    owner      = string    
  })

  default = {
    nombre     = "Virginia"
    cantidad   = 1
    cidrs      = ["10.10.0.0/16"]
    disponible = true
    env        = "Dev"
    owner      = "User    
  }
}

Use:
resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia.cidrs[0]

  tags = {
    Name = var.virginia.nombre
    name = var.virginia.nombre
    env  = var.virginia.env
  }
}
```

20. Tupla Type
```
variable "ohio" {
  type    = tupla([string,string,number,bool,string])
  default = ["Ohio","10.20.0.0/16",1,false,"Dev"]
}

Use:
resource "aws_vpc" "vpc_ohio" {
  cidr_block = var.ohio[1]

  tags = {
    Name   = var.ohio[0]
    name   = var.ohio[0]
    env    = var.ohio[4]
  }
}

```

21. Terraform **output**, is show after a terraform apply in outputs sections 
```
{
  output "linux_public_ip" {
    value  = aws_instance.linux.public_ip,
    description = "Show public ip assigned to the instance"
  }
}


$terraform output      // Show the output from the last execution.
linux_public_ip = "100.26.230.65"
```

22. Explicit dependencies.
```
depends_on = [
  aws_subnet.public_subnet
]
```

23. **lifecycle**. Covers lifeCycle conditions.
```
lifecycle {
  create_before_destroy = true                  #change the default order of creation.
  prevent_destroy       = true                  #prevent to destroy object. will fail.
  ignore_changes        = [ key_name ]          #Changes to specified element will be ignore
  replace_triggered_by  = [ aws_subnet.private_subnet]       #trigger if the dependency change.
}
```

24. Local **provisioner**. Allow execute commands locally
```
provisioner "local-exec" {
  command = "echo instance created with IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
}

provisioner "local-exec" {
  when: destroy
  command = "echo instance IP ${aws_instance.public_instance.public_ip} destruida >> datos_instancia.txt"
}

```

25. Remote **provisioner**. Execute commands in remote instance.
```
provisioner "remote-exec" {
  inline = [
    "echo 'hola mundo' >> ~/saludo.txt"
  ]

  connection {
    type   = "ssh"
    host   = self.public_ip
    user   = "ec2-user"
    private_key = file("mykey.pem")
  }
}
```

26. **user_data**. Allow execute remote commands, defined as attribute when deploy instance., but we don't need define connections.
```
resource "aws_instance" "my_instance" {
  ...
  ...
  ...
  user_data = <<EOF
    !#/bin/bash
    echo "This is a message" > ~/message.txt
  EOF
}
```

27. **taint / untaint** , mark a resource as 'taint' or 'untaint' in order to be replaced in next execution of apply. but terraform apply --replace is more used.
```
terraform taint aws_instance.public_instance
terraform untaint aws_instance.public_instance

```

28. **Debug levels**, is defined using command line using environment variables.
```
Levels: Info, Warning, Error, Debug, Trace 

$export TF_LOG=TRACE
$export TF_LOG_PATH=terra_log.txt

or Windows

SET TF_LOG=TRACE
SET TF_LOG_PATH=terra_log.txt
```

29. **state** , show state and commands related. \
[ list ] .- list resources\
[ rm id-resource]
```
terraform state rm resource-id
```

30. **import** , import resource already deployed with the providers
```
terraform import aws_instance.mywebserver i-12344
```

31. **workspace**, define workspace environment in order to deploy same but in another environments. \
[ list ] .- List all available workspaces.\
[ new workspace-name ] .- Add a new workspace.\
[ show ] .- Show current workspace selected.\
[ select workspace-name ] .- Select a specific workspace.\
[ delete workspace-name ] .- Delete a workspace.
```
terraform workspace list
terraform workspace new dev
terraform workspace show
terraform workspace select default
terraform workspace delete dev

How to use:
resource "aws_vpc" "vcp_virginia" {
  ...
  cidr_block = lookup(var.virginia_cidr,terraform.workspace)
  ...
}
...
```

32. **for_each**, iterate using set or map.
```
...
for_each     = var.instances
...
or if var instances is and array

for_each     = toset(var.instances)
...
How use:

tags = {
  Name = each.value
}
```

33. **console** , Open terraform console to test function or run commands.
```
terraform console
>
Some functions are: toset , length , ceil, min, max, split , lower, upper, title, substring, join, index , element \
                    contains, keys, values, lookup
```

34. Conditional provisioning using ternary operator.
```
variable "enable_monitoring" {
  type     = boolean
  default  = true 
}
...
count    = var.enable_monitoring ? 1 : 0
...
```

35. **locals** , define constants to use with name conventions or other applications.\
locals.tf .- define locals.\
**local**.constant .- to use entry.
```
locals.tf

locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}" 
}

How use:
...
tags = {
  Name = "public_instance-${local.sufix}"
}
...
```

36. **Dynamic Blocks**, allow define blocks to reuse code.
```
...
dynamic "ingress" {
  for_each      = var.ingress_port_list
  content  {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = [var.sg_ingress_cidr]
  }
}
...
```

37. **module** split code for reause and maintability.\
modules are split in new directories internally contains\
main.tf\
variables.tf\
output.tf\
\
How call:
```
module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = "uniquemodulename23jk45"
}
```
\
bucket_name is a variable defined in variables.tf inside the module.

38. Additional tools.\
infracost   .- Provide details about the cost related with our resource to deploy. \
tfsec       .- Provide recomendation about security vulnerabilities found in our current terraform code. \
tflint      .- Validate configuration in our terraform code.\
tfenv       .- Enable terraform version management. enabling working with different terraform version.

39. **Sentinel**, is a policy as Code tools that can be integrated with terraform, runs before apply resources to validate policy compliance.

40. **Alias**, use alias to allow define multiple configuration for same provider and used mainly for segregate regions
```
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
```
41. **force-unlock**, remove the lock on the state for the current configuration.
```
terraform force-unlock
```

42. **2 Spaces**, is the recomendation from Harsicorp to indent when define code.

43. **10** , is the maximun resource provision concurrently during terraform apply.

44. **Aws register account**
```
aws configure
```
```
aws sts get-caller-identity
```