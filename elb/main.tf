# ========================================================================
# ALB 作成 (+ subnets , security Group 紐付け)
# https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/introduction.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
# ========================================================================

# TODO::ALB の接続設定をprivateに変更
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = var.app_name

  security_groups = [aws_security_group.main.id]
  subnets         = var.public_subnet_ids
}

# Security Group
resource "aws_security_group" "main" {
  name        = "${var.app_name}-alb"
  description = "${var.app_name}-alb"
  vpc_id      = var.vpc_id

  # セキュリティグループ内のリソースからインターネットへのアクセスを許可する
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# http通信を受け取れるように
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.main.id

  # セキュリティグループ内のリソースへインターネットからのアクセスを許可する
  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ============================================================
# 接続リクエストのLBの設定(リスナーの追加) (HTTP)
# 
# これがないとALBにアクセスできない 
# 設定するとDNSにアクセスした際にALBがhttpを受け付けるように
# ============================================================
resource "aws_lb_listener" "http" {
  # HTTPでのアクセスを受け付ける
  port = 80
  protocol = "HTTP"

  # ALBのarnを指定( arn: Amazon Resource Names の略で、その名の通りリソースを特定するための一意な名前(id))
  load_balancer_arn = aws_lb.main.arn
  
  # httpで来たリクエストをhttpsへリダイレクトさせる
  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}