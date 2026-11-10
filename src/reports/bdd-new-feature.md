# hw-bdd-new-feature：用 Cucumber 场景驱动“按导演找相似电影”功能

分支 `edidada/cs169-labs`（自官方 starter `276700938a777c6e3f8f99c5ef5a0f148b0a9819` 建立）。

## 原始 starter 保全说明

- 官方场景文件 `features/movies_by_director.feature`（3 个场景）、`features/step_definitions/web_steps.rb`、`features/support/env.rb` 与 starter 内容保持一致，未做修改。
- starter 本体是 Rails 4.2.10 / Ruby 2.6.6 / bundler 1.17.3 老栈（与 sandbox 课程 Codio 环境一致），CI 亦按该版本组合运行。

## 实现清单（按官方 instructions 三部分驱动）

1. **Part 1 director 字段**
   - `db/migrate/20261110000000_add_director_to_movies.rb`：`add_column :movies, :director, :string`。
   - `movies_controller.rb#movie_params` 允许 `:director`，否则强参数会剥离它。
   - `new.html.erb` / `edit.html.erb` 增加 Director 文本框（label "Director"）。
2. **Part 2 场景驱动**
   - `app/models/movie.rb#others_by_same_director`：按 director 匹配且排除自身；无 director 返回 `[]`。
   - `config/routes.rb`：`resources :movies` 内 member 路由 `get 'similar'`（`GET /movies/:id/similar`，helper `similar_movie_path`）。
   - `movies_controller.rb#similar`：无 director → `redirect_to movies_path` + `flash[:warning] = "'<title>' has no director info"`；有 director → `@director` 与 `@movies` 后渲染 `show_by_director`。
   - `show.html.erb` 增加 "Find Movies With Same Director" 链接与条件性 Director 详情行；`index.html.erb` 增加 `flash[:warning]` 的 Bootstrap `alert alert-warning` 展示块。
   - `features/support/paths.rb` 增加 details / edit / Similar Movies 页（按标题 `Movie.find_by!` 解析）映射。
   - `features/step_definitions/movies_steps.rb` 增加 step `the director of "(.*)" should be "(.*)"`（DB 断言）。
3. **补充场景**：`features/similar_director_edge.feature` 验证“该导演没有其他电影”时 Similar Movies 页正常渲染（非官方场景，官方 3 场景保持原样）。

## CI

`.github/workflows/hw.yml`：ruby 2.6.6 + bundler 1.17.3（与 `Gemfile.lock` 锁定一致）；sqlite3 1.3.11 / nokogiri 1.8.4 用系统库编译；`rails db:create db:migrate RAILS_ENV=test` 后执行 `cucumber --backtrace`，并对 `N scenarios (N passed)` / `N steps (N passed)` 汇总行断言，防止 0/0 通过。

## 已通过的公开验证（2026-11-10）

验收分支 `edidada/cs169-labs`；实现最终 HEAD `1b4e8312514586e1f157bced2c62ef9bd67508c4`（run [42822152038](https://github.com/edidada/cs169-hw-bdd-new-feature/actions/runs/42822152038) `success`，docs/报告 HEAD 另见下方运行记录）。Cucumber 汇总：

- `4 scenarios (4 passed)`，`22 steps (22 passed)`
  - 官方 `features/movies_by_director.feature` 3 个场景全部通过：
    1. add director to existing movie —— 编辑页按 Director 标签填入 "Ridley Scott" 并 Update Movie Info，DB 断言 `the director of "Alien" should be "Ridley Scott"`；
    2. find movie with same director —— Star Wars 详情页 Follow "Find Movies With Same Director"，进入 Similar Movies 页看到 THX-1138、看不到 Blade Runner；
    3. sad path —— 无 Director 的 Alien 触发 `flash[:warning] = "'Alien' has no director info"`
 回到 movies 首页。
  - 补充场景 `features/similar_director_edge.feature`：导演无其他电影时 Similar Movies 页正常渲染（非官方场景）。
- workflows 的汇总断言防止 0/0 或 skipped/failed 混入。

## CI 修复史（保留）

1. run 42821445777：Rails 4.2 的 `rails` binstub 不识别 `db:*` 命令（Rails 5+ 才内置），改用 `bundle exec rake db:create db:migrate`。
2. run 42821773609：官方 starter 的 `app/models/movie.rb` 继承 `ApplicationRecord`，但 starter 是 Rails 4.2.10（该基类 Rails 5 才有）且仓库内无定义 —— 按官方 starter 文件不动模型类行的原则，补 `app/models/application_record.rb`（标准抽象基类 shim），随后成功。

## 边界与局限

- 验收仅覆盖官方 starter 场景 + 1 条补充场景；不宣称 SAAS edx 侧 autograder 或最终 deploy 的任何状态。
- Rails 4.2.10 老 gem 栈（含 nokogiri 1.8.4 / sqlite3 1.3.11）在本 CI 用系统库编译；未改动官方 `Gemfile` / `Gemfile.lock`。
- 本地仅静态核对，所有执行在 GitHub Actions。
